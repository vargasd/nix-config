# Implements the color256 algorithm from https://github.com/jake-stewart/color256
# Takes the 16-color base palette and generates a full 256-color indexed palette.
#
# Colors 0-15:   base16 ansi palette (0=bg, 7=gray, 8=bright_black, 15=white/fg)
# Colors 16-231: 6x6x6 color cube, interpolated in CIELAB colorspace
# Colors 232-255: 24 greyscale ramp from bg to fg
colors:
let
  # ── math helpers ───────────────────────────────────────────────────────────
  clamp =
    low: high: n:
    if n < low then
      low
    else if n > high then
      high
    else
      n;

  # Integer modulo (builtins.rem doesn't exist)
  intRem = n: d: n - (builtins.div n d) * d;

  # Natural logarithm using the identity ln(x) = 2*sum_{k=0}^inf t^(2k+1)/(2k+1)
  # where t = (x-1)/(x+1). Range-reduced via x = m * 2^e with m in [0.5, 1).
  ln2 = 0.6931471805599453;

  lnCore =
    x:
    let
      t = (x - 1.0) / (x + 1.0);
      t2 = t * t;
      result =
        builtins.foldl'
          (
            acc: k:
            let
              term = acc.term * t2;
            in
            {
              term = term;
              sum = acc.sum + term / ((2 * k + 1) * 1.0);
            }
          )
          {
            term = t;
            sum = t;
          }
          (builtins.genList (k: k + 1) 19);
    in
    2.0 * result.sum;

  goReduce =
    m: e:
    if m >= 1.0 then
      goReduce (m / 2.0) (e + 1)
    else if m < 0.5 then
      goReduce (m * 2.0) (e - 1)
    else
      { inherit m e; };

  ln =
    x:
    let
      r = goReduce x 0;
    in
    r.e * ln2 + lnCore r.m;

  # exp(x) = 2^n * exp(r) where n = round(x/ln2), r = x - n*ln2 (|r| < 0.5*ln2)
  intPow2 =
    n:
    if n == 0 then
      1.0
    else if n > 0 then
      2.0 * (intPow2 (n - 1))
    else
      0.5 * (intPow2 (n + 1));

  expSmall =
    x:
    let
      result =
        builtins.foldl'
          (
            acc: k:
            let
              term = acc.term * x / (k * 1.0);
            in
            {
              term = term;
              sum = acc.sum + term;
            }
          )
          {
            term = 1.0;
            sum = 1.0;
          }
          (builtins.genList (k: k + 1) 20);
    in
    result.sum;

  exp =
    x:
    let
      n = builtins.floor (x / ln2 + 0.5);
      r = x - n * ln2;
    in
    intPow2 n * expSmall r;

  # pow: x^y = exp(y * ln(x))
  pow = base: e: exp (e * (ln base));

  # ── hex helpers ────────────────────────────────────────────────────────────
  hexByte = s: builtins.fromTOML "v = 0x${s}" |> (x: x.v);

  hexToRgb = hex: {
    r = hexByte (builtins.substring 0 2 hex);
    g = hexByte (builtins.substring 2 2 hex);
    b = hexByte (builtins.substring 4 2 hex);
  };

  intToHex2 =
    n:
    let
      digits = "0123456789abcdef";
      hi = builtins.substring (builtins.div n 16) 1 digits;
      lo = builtins.substring (intRem n 16) 1 digits;
    in
    "${hi}${lo}";

  rgbToHex = rgb: "${intToHex2 rgb.r}${intToHex2 rgb.g}${intToHex2 rgb.b}";

  # ── sRGB <-> linear ────────────────────────────────────────────────────────
  srgbToLinear =
    c:
    let
      f = c / 255.0;
    in
    if f <= 0.04045 then f / 12.92 else pow ((f + 0.055) / 1.055) 2.4;

  linearToSrgb = c: if c <= 0.0031308 then 12.92 * c else 1.055 * (pow c (1.0 / 2.4)) - 0.055;

  # ── CIELAB conversions ─────────────────────────────────────────────────────
  labF = t: if t > 0.008856 then pow t (1.0 / 3.0) else 7.787 * t + 16.0 / 116.0;

  # rgb { r g b } -> lab { l a b }
  rgbToLab =
    rgb:
    let
      r = srgbToLinear rgb.r;
      g = srgbToLinear rgb.g;
      b = srgbToLinear rgb.b;

      xn = (r * 0.4124 + g * 0.3576 + b * 0.1805) / 0.95047;
      yn = (r * 0.2126 + g * 0.7152 + b * 0.0722) / 1.0;
      zn = (r * 0.0193 + g * 0.1192 + b * 0.9505) / 1.08883;

      fx = labF xn;
      fy = labF yn;
      fz = labF zn;
    in
    {
      l = 116.0 * fy - 16.0;
      a = 500.0 * (fx - fy);
      b = 200.0 * (fy - fz);
    };

  # lab { l a b } -> rgb { r g b }
  labToRgb =
    lab:
    let
      fy = (lab.l + 16.0) / 116.0;
      fx = lab.a / 500.0 + fy;
      fz = fy - lab.b / 200.0;

      invF =
        t:
        let
          t3 = t * t * t;
        in
        if t3 > 0.008856 then t3 else (t - 16.0 / 116.0) / 7.787;

      x = (invF fx) * 0.95047;
      y = invF fy;
      z = (invF fz) * 1.08883;

      rl = x * 3.2406 + y * (-1.5372) + z * (-0.4986);
      gl = x * (-0.9689) + y * 1.8758 + z * 0.0415;
      bl_ = x * 0.0557 + y * (-0.2040) + z * 1.0570;

      toSrgb8 = c: clamp 0 255 (builtins.floor (linearToSrgb c * 255.0 + 0.5));
    in
    {
      r = toSrgb8 rl;
      g = toSrgb8 gl;
      b = toSrgb8 bl_;
    };

  # ── linear interpolation in LAB ─────────────────────────────────────────────
  lerpLab = t: lab1: lab2: {
    l = lab1.l + t * (lab2.l - lab1.l);
    a = lab1.a + t * (lab2.a - lab1.a);
    b = lab1.b + t * (lab2.b - lab1.b);
  };

  # ── base16 palette from flake.nix colors ───────────────────────────────────
  # Index mapping matches color256 convention:
  #   0  = bg,           7  = gray (mid),   8  = bright_black,  15 = white (fg)
  #   1-6 = dark colours, 9-14 = bright colours
  base16 = [
    colors.background # 0  black / bg
    colors.dark_red # 1
    colors.dark_green # 2
    colors.dark_yellow # 3
    colors.dark_blue # 4
    colors.dark_magenta # 5
    colors.dark_cyan # 6
    colors.gray # 7  white-ish
    colors.bright_black # 8
    colors.red # 9
    colors.yellow # 10
    colors.green # 11
    colors.blue # 12
    colors.magenta # 13
    colors.cyan # 14
    colors.white # 15 fg
  ];

  # ── generate_256_palette ───────────────────────────────────────────────────
  generate256Palette =
    let
      bgLab = rgbToLab (hexToRgb (builtins.elemAt base16 0));
      fgLab = rgbToLab (hexToRgb (builtins.elemAt base16 15));

      # base8 in LAB: [bg, dark1..dark6, fg]
      base8Lab = [
        bgLab
        (rgbToLab (hexToRgb (builtins.elemAt base16 1)))
        (rgbToLab (hexToRgb (builtins.elemAt base16 2)))
        (rgbToLab (hexToRgb (builtins.elemAt base16 3)))
        (rgbToLab (hexToRgb (builtins.elemAt base16 4)))
        (rgbToLab (hexToRgb (builtins.elemAt base16 5)))
        (rgbToLab (hexToRgb (builtins.elemAt base16 6)))
        fgLab
      ];

      get = builtins.elemAt base8Lab;

      # 6x6x6 cube: indices 16-231
      # For each (r,g,b) in 0..5:
      #   c0 = lerp(r/5, base8[0], base8[1])   c1 = lerp(r/5, base8[2], base8[3])
      #   c2 = lerp(r/5, base8[4], base8[5])   c3 = lerp(r/5, base8[6], base8[7])
      #   c4 = lerp(g/5, c0, c1)               c5 = lerp(g/5, c2, c3)
      #   result = lerp(b/5, c4, c5)
      cubeEntries = builtins.concatLists (
        map (
          r:
          builtins.concatLists (
            map (
              g:
              map (
                b:
                let
                  rf = r / 5.0;
                  gf = g / 5.0;
                  bf = b / 5.0;
                  c0 = lerpLab rf (get 0) (get 1);
                  c1 = lerpLab rf (get 2) (get 3);
                  c2 = lerpLab rf (get 4) (get 5);
                  c3 = lerpLab rf (get 6) (get 7);
                  c4 = lerpLab gf c0 c1;
                  c5 = lerpLab gf c2 c3;
                  c6 = lerpLab bf c4 c5;
                in
                rgbToHex (labToRgb c6)
              ) (builtins.genList (b: b) 6)
            ) (builtins.genList (g: g) 6)
          )
        ) (builtins.genList (r: r) 6)
      );

      # 24 greyscale steps: indices 232-255, t = (i+1)/25
      greyEntries = map (
        i:
        let
          t = (i + 1) / 25.0;
        in
        rgbToHex (labToRgb (lerpLab t bgLab fgLab))
      ) (builtins.genList (i: i) 24);

    in
    base16 ++ cubeEntries ++ greyEntries;

in
generate256Palette
