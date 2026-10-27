Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot  = Split-Path -Parent $ScriptDir
$AssetsDir = Join-Path $RepoRoot "assets"
$BrandDir  = Join-Path $AssetsDir "brand"

$DataPath  = Join-Path $ScriptDir "profile-data.json"
$DataJson  = [System.IO.File]::ReadAllText($DataPath, [System.Text.Encoding]::UTF8)
$D         = $DataJson | ConvertFrom-Json

$MarkBytes = [System.IO.File]::ReadAllBytes((Join-Path $BrandDir "home-mark-transparent.webp"))
$WordBytes = [System.IO.File]::ReadAllBytes((Join-Path $BrandDir "wordmark.webp"))
$MarkB64   = [System.Convert]::ToBase64String($MarkBytes)
$WordB64   = [System.Convert]::ToBase64String($WordBytes)

$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Esc([string]$s) {
    if ($null -eq $s) { return "" }
    return [System.Security.SecurityElement]::Escape($s)
}

function Save-Svg([string]$fileName, [string]$svgContent) {
    $outPath = Join-Path $AssetsDir $fileName
    [System.IO.File]::WriteAllText($outPath, $svgContent, $Utf8NoBom)
    $xml = New-Object System.Xml.XmlDocument
    $xml.XmlResolver = $null
    $xml.Load($outPath)
    $kb = [Math]::Round(([System.IO.FileInfo]$outPath).Length / 1024.0, 1)
    Write-Host ("[OK] Validated XML/SVG -> assets/{0} ({1} KB)" -f $fileName, $kb)
}

# ==============================================================================
# 1. HERO CINEMA STAGE (960 x 392)
# ==============================================================================
$heroSvg = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 392" width="960" height="392" role="img" aria-label="Mohammad Navidi - Navidix Studio">
  <defs>
    <linearGradient id="bgGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#1D2B47"/>
      <stop offset="48%" stop-color="#111A2E"/>
      <stop offset="100%" stop-color="#090E1A"/>
    </linearGradient>
    <radialGradient id="blueBloom" cx="24%" cy="28%" r="52%">
      <stop offset="0%" stop-color="#2B6CFF" stop-opacity="0.26"/>
      <stop offset="55%" stop-color="#2B6CFF" stop-opacity="0.07"/>
      <stop offset="100%" stop-color="#2B6CFF" stop-opacity="0"/>
    </radialGradient>
    <radialGradient id="redBloom" cx="80%" cy="50%" r="36%">
      <stop offset="0%" stop-color="#E3202A" stop-opacity="0.30"/>
      <stop offset="55%" stop-color="#E3202A" stop-opacity="0.08"/>
      <stop offset="100%" stop-color="#E3202A" stop-opacity="0"/>
    </radialGradient>
    <linearGradient id="edgeLaser" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#090E1A" stop-opacity="0"/>
      <stop offset="22%" stop-color="#E3202A" stop-opacity="0.95"/>
      <stop offset="52%" stop-color="#FF6A5A" stop-opacity="0.9"/>
      <stop offset="78%" stop-color="#2B6CFF" stop-opacity="0.95"/>
      <stop offset="100%" stop-color="#090E1A" stop-opacity="0"/>
    </linearGradient>
    <linearGradient id="titleGrad" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#FFFFFF"/>
      <stop offset="65%" stop-color="#E8F0FF"/>
      <stop offset="100%" stop-color="#9CC4FF"/>
    </linearGradient>
    <linearGradient id="sheenGrad" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#FFFFFF" stop-opacity="0"/>
      <stop offset="50%" stop-color="#FFFFFF" stop-opacity="0.42"/>
      <stop offset="100%" stop-color="#FFFFFF" stop-opacity="0"/>
    </linearGradient>
    <pattern id="draftGrid" width="44" height="44" patternUnits="userSpaceOnUse">
      <path d="M 44 0 L 0 0 0 44" fill="none" stroke="#8AB4F8" stroke-opacity="0.065" stroke-width="1"/>
    </pattern>
    <clipPath id="cardClip">
      <rect x="2" y="2" width="956" height="388" rx="18"/>
    </clipPath>
    <clipPath id="hexMarkClip">
      <polygon points="0,-66 57,-33 57,33 0,66 -57,33 -57,-33"/>
    </clipPath>
  </defs>

  <style><![CDATA[
    .sans { font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, 'Inter', Roboto, Helvetica, Arial, sans-serif; }
    .fa   { font-family: 'Estedad', 'Vazirmatn', 'Segoe UI', Tahoma, sans-serif; }
    .mono { font-family: 'JetBrains Mono', 'Cascadia Code', 'Fira Code', Consolas, 'Courier New', monospace; }

    .role-line { opacity: 0; animation: roleCycle 16s cubic-bezier(0.16, 1, 0.3, 1) infinite; }
    .r1 { animation-delay: 0s; }
    .r2 { animation-delay: -12s; }
    .r3 { animation-delay: -8s; }
    .r4 { animation-delay: -4s; }

    @keyframes roleCycle {
      0%   { opacity: 0; transform: translateY(7px); }
      3.5% { opacity: 1; transform: translateY(0px); }
      21.5%{ opacity: 1; transform: translateY(0px); }
      25%  { opacity: 0; transform: translateY(-7px); }
      100% { opacity: 0; transform: translateY(-7px); }
    }

    .rec-dot { animation: blinkRec 1.6s ease-in-out infinite; }
    @keyframes blinkRec {
      0%, 100% { opacity: 1; }
      50%      { opacity: 0.22; }
    }

    .cursor-blink { animation: blinkCur 1.05s steps(2, start) infinite; }
    @keyframes blinkCur {
      0%, 100% { opacity: 0.95; }
      50%      { opacity: 0.1; }
    }

    .hex-trace {
      stroke-dasharray: 180 500;
      animation: traceDash 8s linear infinite;
    }
    @keyframes traceDash {
      from { stroke-dashoffset: 680; }
      to   { stroke-dashoffset: 0; }
    }

    @media (prefers-reduced-motion: reduce) {
      .role-line, .rec-dot, .cursor-blink, .hex-trace { animation: none !important; }
      .r1 { opacity: 1 !important; }
    }
  ]]></style>

  <!-- Main Backlit Studio Stage -->
  <g clip-path="url(#cardClip)">
    <rect x="2" y="2" width="956" height="388" fill="url(#bgGrad)"/>
    <rect x="2" y="2" width="956" height="388" fill="url(#draftGrid)"/>

    <!-- Breathing Ambient Studio Backlights -->
    <rect x="2" y="2" width="956" height="388" fill="url(#blueBloom)">
      <animate attributeName="opacity" values="0.72;1;0.72" dur="7s" repeatCount="indefinite"/>
    </rect>
    <rect x="2" y="2" width="956" height="388" fill="url(#redBloom)">
      <animate attributeName="opacity" values="1;0.65;1" dur="5.6s" repeatCount="indefinite"/>
    </rect>

    <!-- Signature Navidix Drifting Crimson -> Ion-Blue Hairlines -->
    <rect x="-320" y="2" width="640" height="2.2" fill="url(#edgeLaser)">
      <animate attributeName="x" values="-360;680;-360" dur="11s" repeatCount="indefinite"/>
    </rect>
    <rect x="640" y="387.8" width="640" height="2.2" fill="url(#edgeLaser)">
      <animate attributeName="x" values="680;-360;680" dur="11s" repeatCount="indefinite"/>
    </rect>
  </g>

  <!-- Outer Precision Border -->
  <rect x="2" y="2" width="956" height="388" rx="18" fill="none" stroke="#2B3D5F" stroke-width="1.4"/>

  <!-- Cinema Viewfinder Corner Ticks -->
  <g stroke="#7FA6E0" stroke-opacity="0.42" stroke-width="1.3" fill="none">
    <path d="M 20 33 L 20 20 L 33 20"/>
    <path d="M 927 20 L 940 20 L 940 33"/>
    <path d="M 20 359 L 20 372 L 33 372"/>
    <path d="M 927 372 L 940 372 L 940 359"/>
  </g>

  <!-- Top-Right Cinema Telemetry -->
  <g transform="translate(652, 34)">
    <circle cx="0" cy="-3.6" r="3.8" fill="#E3202A" class="rec-dot"/>
    <text x="11" y="0" class="mono" font-size="10.5" fill="#8DA5CC" letter-spacing="1.1">REC &#183; 24.00 FPS &#183; ANAMORPHIC &#183; 2026</text>
  </g>

  <!-- ==================== LEFT EDITORIAL & CODE COLUMN ==================== -->
  <!-- Eyebrow Pill -->
  <rect x="44" y="28" width="322" height="26" rx="13" fill="#13203B" fill-opacity="0.88" stroke="#365387" stroke-width="1"/>
  <circle cx="60" cy="41" r="4" fill="#38BDF8">
    <animate attributeName="r" values="3.2;4.6;3.2" dur="2.2s" repeatCount="indefinite"/>
    <animate attributeName="opacity" values="0.7;1;0.7" dur="2.2s" repeatCount="indefinite"/>
  </circle>
  <text x="73" y="45" class="mono" font-size="11" font-weight="600" fill="#B9D5FF" letter-spacing="1.2">$(Esc $D.eyebrow)</text>

  <!-- Official Metallic Wordmark + Persian Brand Tag -->
  <image href="data:image/webp;base64,$WordB64" x="44" y="72" width="218" height="34" preserveAspectRatio="xMinYMid meet"/>
  <line x1="276" y1="75" x2="276" y2="103" stroke="#334971" stroke-width="1.2"/>
  <text x="290" y="95" class="fa" font-size="15.5" font-weight="700" fill="#C6D8F5">$(Esc $D.studio_fa)</text>

  <!-- Ghosted Surname Backdrop + Main Founder Headline -->
  <text x="42" y="148" class="sans" font-size="60" font-weight="900" fill="none" stroke="#8FDBFF" stroke-opacity="0.06" letter-spacing="7">NAVIDI</text>
  <text x="44" y="152" class="sans" font-size="43" font-weight="800" fill="url(#titleGrad)" letter-spacing="-0.6">$(Esc $D.name)</text>
  <text x="462" y="149" class="fa" font-size="15" font-weight="600" fill="#8AA4CE">&#183;  $(Esc $D.name_fa)</text>

  <!-- Animated Code-Driven Cycling Role Terminal -->
  <rect x="44" y="170" width="540" height="44" rx="10" fill="#080D18" fill-opacity="0.92" stroke="#283B60" stroke-width="1.2"/>
  <text x="58" y="197" class="mono" font-size="13" font-weight="700" fill="#FF5A5F">nvx:~`$</text>

  <g transform="translate(116, 197)" class="mono" font-size="13" fill="#E6F0FF">
    <text x="0" y="0" class="role-line r1">role --founder "Creative Technologist &amp; AI Director"</text>
    <text x="0" y="0" class="role-line r2">gateway.sync({ models: 444, engine: "Navidix 2026" })</text>
    <text x="0" y="0" class="role-line r3">direct --cinema "Science, Space &amp; Tech Docs (FA)"</text>
    <text x="0" y="0" class="role-line r4">echo "From One Sentence, To One Frame &#183; $(Esc $D.motto_fa)"</text>
  </g>
  <rect x="564" y="183" width="7" height="17" rx="1.5" fill="#38BDF8" class="cursor-blink"/>

  <!-- Editorial Manifesto -->
  <text x="44" y="242" class="sans" font-size="14" font-weight="500" fill="#D5E3FA">$(Esc $D.bio_line_1)</text>
  <text x="44" y="265" class="sans" font-size="13.5" fill="#93AACF">$(Esc $D.bio_line_2)  <tspan class="fa" fill="#FF7B73" font-weight="600">($(Esc $D.less_talk_fa))</tspan></text>

  <!-- Bottom 4 HUD Telemetry Pods -->
  <g transform="translate(44, 288)">
    <rect x="0" y="0" width="126" height="66" rx="11" fill="#0D1628" fill-opacity="0.88" stroke="#2B3E63" stroke-width="1"/>
    <line x1="12" y1="1" x2="64" y2="1" stroke="#E3202A" stroke-width="2"/>
    <text x="14" y="31" class="sans" font-size="22" font-weight="800" fill="#FFFFFF">444+</text>
    <text x="14" y="50" class="mono" font-size="9.8" font-weight="600" fill="#8FA8D0" letter-spacing="0.8">ACTIVE MODELS</text>
  </g>
  <g transform="translate(182, 288)">
    <rect x="0" y="0" width="126" height="66" rx="11" fill="#0D1628" fill-opacity="0.88" stroke="#2B3E63" stroke-width="1"/>
    <line x1="12" y1="1" x2="64" y2="1" stroke="#38BDF8" stroke-width="2"/>
    <text x="14" y="31" class="sans" font-size="22" font-weight="800" fill="#8FDBFF">1,800+</text>
    <text x="14" y="50" class="mono" font-size="9.8" font-weight="600" fill="#8FA8D0" letter-spacing="0.8">STUDIO COMMITS</text>
  </g>
  <g transform="translate(320, 288)">
    <rect x="0" y="0" width="126" height="66" rx="11" fill="#0D1628" fill-opacity="0.88" stroke="#2B3E63" stroke-width="1"/>
    <line x1="12" y1="1" x2="64" y2="1" stroke="#A78BFA" stroke-width="2"/>
    <text x="14" y="31" class="sans" font-size="22" font-weight="800" fill="#DDD6FE">93</text>
    <text x="14" y="50" class="mono" font-size="9.8" font-weight="600" fill="#8FA8D0" letter-spacing="0.8">NVX JS MODULES</text>
  </g>
  <g transform="translate(458, 288)">
    <rect x="0" y="0" width="126" height="66" rx="11" fill="#0D1628" fill-opacity="0.88" stroke="#2B3E63" stroke-width="1"/>
    <line x1="12" y1="1" x2="64" y2="1" stroke="#34D399" stroke-width="2"/>
    <text x="14" y="31" class="sans" font-size="21" font-weight="800" fill="#6EE7B7">FA &#183; EN</text>
    <text x="14" y="50" class="mono" font-size="9.8" font-weight="600" fill="#8FA8D0" letter-spacing="0.8">PERSIAN AI LAB</text>
  </g>

  <!-- ==================== RIGHT HEXAGONAL APERTURE STAGE ==================== -->
  <g transform="translate(772, 194)">
    <g>
      <animateTransform attributeName="transform" type="rotate" from="360 0 0" to="0 0 0" dur="44s" repeatCount="indefinite"/>
      <circle cx="0" cy="0" r="142" fill="none" stroke="#9CC2F5" stroke-opacity="0.28" stroke-width="1.5" stroke-dasharray="2 10"/>
      <circle cx="0" cy="0" r="131" fill="none" stroke="#E3202A" stroke-opacity="0.32" stroke-width="1.1" stroke-dasharray="1.5 22"/>
      <circle cx="0" cy="-142" r="3.2" fill="#8FDBFF"/>
      <circle cx="0" cy="142" r="2.6" fill="#8FDBFF" fill-opacity="0.7"/>
    </g>

    <g stroke="#9CC2F5" stroke-opacity="0.45" stroke-width="1.3">
      <line x1="-154" y1="0" x2="-145" y2="0"/>
      <line x1="145" y1="0" x2="154" y2="0"/>
      <line x1="0" y1="-154" x2="0" y2="-145"/>
      <line x1="0" y1="145" x2="0" y2="154"/>
    </g>

    <polygon points="0,-116 100.5,-58 100.5,58 0,116 -100.5,58 -100.5,-58" fill="none" stroke="#8AB4F8" stroke-opacity="0.22" stroke-width="1.2"/>
    <polygon points="0,-116 100.5,-58 100.5,58 0,116 -100.5,58 -100.5,-58" fill="none" stroke="#8FDBFF" stroke-opacity="0.75" stroke-width="1.6" class="hex-trace"/>

    <g>
      <animateTransform attributeName="transform" type="rotate" from="0 0 0" to="360 0 0" dur="26s" repeatCount="indefinite"/>
      <polygon points="96,0 48,-83.1 -48,-83.1 -96,0 -48,83.1 48,83.1" fill="none" stroke="#E3202A" stroke-opacity="0.45" stroke-width="1.3"/>
      <circle cx="96" cy="0" r="3.6" fill="#FF5A5F"/>
      <circle cx="-96" cy="0" r="2.8" fill="#E3202A"/>
    </g>

    <g>
      <animateTransform attributeName="transform" type="translate" values="0,-4.5; 0,4.5; 0,-4.5" dur="5.2s" repeatCount="indefinite"/>
      <image href="data:image/webp;base64,$MarkB64" x="-68" y="-68" width="136" height="136" preserveAspectRatio="xMidYMid meet"/>
      <g clip-path="url(#hexMarkClip)">
        <polygon points="-32,-80 4,-80 36,80 0,80" fill="url(#sheenGrad)">
          <animateTransform attributeName="transform" type="translate" values="-145,0; 145,0; 145,0" keyTimes="0; 0.34; 1" dur="5.8s" repeatCount="indefinite"/>
        </polygon>
      </g>
    </g>
  </g>

  <text x="772" y="362" text-anchor="middle" class="fa" font-size="13" font-weight="600" fill="#B4C7E7">$(Esc $D.creed_fa)</text>
</svg>
"@
Save-Svg "hero-cinema.svg" $heroSvg


# ==============================================================================
# 2. ACTION DOCK PILL BUTTONS (6 Tailored Pills from profile-data.json)
# ==============================================================================
foreach ($b in $D.buttons) {
    $bw = [int]$b.w
    $rw = $bw - 2
    $pulseAnim = ""
    if ($b.primary) {
        $pulseAnim = '<animate attributeName="r" values="3.2;4.5;3.2" dur="1.8s" repeatCount="indefinite"/>'
    }
    $btnSvg = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 $bw 36" width="$bw" height="36" role="img" aria-label="$(Esc $b.label)">
  <defs>
    <linearGradient id="g" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="$($b.bg1)"/>
      <stop offset="100%" stop-color="$($b.bg2)"/>
    </linearGradient>
  </defs>
  <rect x="1" y="1" width="$rw" height="34" rx="10" fill="url(#g)" stroke="$($b.border)" stroke-width="1.25"/>
  <circle cx="17" cy="18" r="3.6" fill="$($b.dot)">$pulseAnim</circle>
  <text x="28" y="22.2" font-family="'Segoe UI', -apple-system, BlinkMacSystemFont, Inter, Roboto, sans-serif" font-size="12" font-weight="700" fill="$($b.text)">$(Esc $b.label)</text>
</svg>
"@
    Save-Svg $b.file $btnSvg
}


# ==============================================================================
# 3. LIVE CODE TERMINAL + MULTI-MODEL NEURAL PIPELINE (960 x 376)
# ==============================================================================
$termSvg = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 376" width="960" height="376" role="img" aria-label="Navidix Multi-Model Code Pipeline">
  <defs>
    <linearGradient id="panelBg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#18243D"/>
      <stop offset="100%" stop-color="#0A101E"/>
    </linearGradient>
    <linearGradient id="ideBg" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#0D1424"/>
      <stop offset="100%" stop-color="#070B14"/>
    </linearGradient>
    <linearGradient id="execHighlight" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#E3202A" stop-opacity="0.26"/>
      <stop offset="48%" stop-color="#2B6CFF" stop-opacity="0.15"/>
      <stop offset="100%" stop-color="#2B6CFF" stop-opacity="0"/>
    </linearGradient>
    <linearGradient id="progGrad" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#E3202A"/>
      <stop offset="55%" stop-color="#2B6CFF"/>
      <stop offset="100%" stop-color="#38BDF8"/>
    </linearGradient>
  </defs>

  <style><![CDATA[
    .sans { font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, 'Inter', Roboto, sans-serif; }
    .fa   { font-family: 'Estedad', 'Vazirmatn', 'Segoe UI', Tahoma, sans-serif; }
    .mono { font-family: 'JetBrains Mono', 'Cascadia Code', 'Fira Code', Consolas, monospace; }

    .kw  { fill: #FF6B81; font-weight: 600; }
    .fn  { fill: #7DD3FC; }
    .str { fill: #A7F3D0; }
    .num { fill: #FDE047; }
    .cmt { fill: #6983A8; font-style: italic; }
    .prp { fill: #C4B5FD; }
    .txt { fill: #E2E8F0; }

    .stage-a { animation: stagePulse 9s ease-in-out 0s infinite; }
    .stage-b { animation: stagePulse 9s ease-in-out -6s infinite; }
    .stage-c { animation: stagePulse 9s ease-in-out -3s infinite; }

    @keyframes stagePulse {
      0%, 100% { opacity: 0.84; }
      18%, 32% { opacity: 1; }
    }

    .cur-ide { animation: curIdeBlink 1s steps(2, start) infinite; }
    @keyframes curIdeBlink {
      0%, 100% { opacity: 0.95; }
      50%      { opacity: 0.1; }
    }

    .wire { stroke-dasharray: 4 6; animation: wireFlow 1.5s linear infinite; }
    @keyframes wireFlow {
      from { stroke-dashoffset: 20; }
      to   { stroke-dashoffset: 0; }
    }

    @media (prefers-reduced-motion: reduce) {
      .stage-a, .stage-b, .stage-c, .cur-ide, .wire { animation: none !important; opacity: 1 !important; }
    }
  ]]></style>

  <!-- Outer Card -->
  <rect x="2" y="2" width="956" height="372" rx="18" fill="url(#panelBg)" stroke="#293B5C" stroke-width="1.4"/>

  <!-- ==================== LEFT: ANIMATED CODE IDE (516px) ==================== -->
  <rect x="18" y="18" width="516" height="340" rx="13" fill="url(#ideBg)" stroke="#263859" stroke-width="1.2"/>
  <path d="M 18 31 Q 18 18 31 18 L 521 18 Q 534 18 534 31 L 534 52 L 18 52 Z" fill="#131E35"/>
  <line x1="18" y1="52" x2="534" y2="52" stroke="#243554" stroke-width="1"/>
  <circle cx="36" cy="35" r="5" fill="#FF5F56"/>
  <circle cx="52" cy="35" r="5" fill="#FFBD2E"/>
  <circle cx="68" cy="35" r="5" fill="#27C93F"/>
  <rect x="88" y="23" width="166" height="29" rx="6" fill="#0B1220" stroke="#263859" stroke-width="1"/>
  <text x="102" y="41" class="mono" font-size="11.5" font-weight="600" fill="#E2E8F0">pipeline.navidix.ts</text>
  <text x="518" y="40" text-anchor="end" class="mono" font-size="10.5" fill="#38BDF8">&#9679; SDK v2026.10</text>

  <!-- Animated Scanning Execution Bar + Left Active Indicator -->
  <g>
    <animateTransform attributeName="transform" type="translate" values="0,0; 0,95; 0,152; 0,0" dur="9s" repeatCount="indefinite"/>
    <rect x="19" y="121" width="514" height="38" fill="url(#execHighlight)"/>
    <rect x="19" y="121" width="2.5" height="38" fill="#E3202A"/>
  </g>

  <!-- Line Numbers -->
  <g class="mono" font-size="11.2" fill="#4B6287" text-anchor="end">
    <text x="45" y="76">01</text>
    <text x="45" y="95">02</text>
    <text x="45" y="114">03</text>
    <text x="45" y="133">04</text>
    <text x="45" y="152">05</text>
    <text x="45" y="171">06</text>
    <text x="45" y="190">07</text>
    <text x="45" y="209">08</text>
    <text x="45" y="228">09</text>
    <text x="45" y="247">10</text>
    <text x="45" y="266">11</text>
    <text x="45" y="285">12</text>
    <text x="45" y="304">13</text>
  </g>
  <line x1="54" y1="53" x2="54" y2="324" stroke="#1B2942" stroke-width="1"/>

  <!-- Always-Crisp Syntax-Highlighted TypeScript Pipeline (2026 Flagship Models) -->
  <g class="mono" font-size="11.5">
    <text x="64" y="76"><tspan class="kw">import</tspan> <tspan class="txt">{ NavidixStudio }</tspan> <tspan class="kw">from</tspan> <tspan class="str">"@navidix/ai-gateway"</tspan><tspan class="txt">;</tspan></text>
    <text x="64" y="95"><tspan class="kw">const</tspan> <tspan class="txt">nvx = </tspan><tspan class="kw">new</tspan> <tspan class="fn">NavidixStudio</tspan><tspan class="txt">({ </tspan><tspan class="prp">models</tspan><tspan class="txt">: </tspan><tspan class="num">444</tspan><tspan class="txt">, </tspan><tspan class="prp">lang</tspan><tspan class="txt">: </tspan><tspan class="str">"fa"</tspan><tspan class="txt"> });</tspan></text>

    <g class="stage-a">
      <text x="64" y="114" class="cmt">// 1. Agentic Architecture, Reasoning &amp; Security Audit</text>
      <text x="64" y="133"><tspan class="kw">const</tspan> <tspan class="txt">script = </tspan><tspan class="kw">await</tspan> <tspan class="txt">nvx.</tspan><tspan class="fn">reason</tspan><tspan class="txt">({</tspan></text>
      <text x="80" y="152"><tspan class="prp">lead</tspan><tspan class="txt">: [</tspan><tspan class="str">"claude-sonnet-5.5"</tspan><tspan class="txt">, </tspan><tspan class="str">"gpt-6-astra"</tspan><tspan class="txt">],</tspan></text>
      <text x="80" y="171"><tspan class="prp">audit</tspan><tspan class="txt">: </tspan><tspan class="str">"gemini-4-argon"</tspan><tspan class="txt">, </tspan><tspan class="prp">fast</tspan><tspan class="txt">: </tspan><tspan class="str">"deepseek-v4.1-flash"</tspan></text>
      <text x="64" y="190"><tspan class="txt">});</tspan></text>
    </g>

    <g class="stage-b">
      <text x="64" y="209" class="cmt">// 2. Studio Keyframes, 100% Face-Lock &amp; Pure Vector SVG</text>
      <text x="64" y="228"><tspan class="kw">const</tspan> <tspan class="txt">art = </tspan><tspan class="kw">await</tspan> <tspan class="txt">nvx.</tspan><tspan class="fn">imagine</tspan><tspan class="txt">({ </tspan><tspan class="prp">raw</tspan><tspan class="txt">: </tspan><tspan class="str">"flux-3-image"</tspan><tspan class="txt">,</tspan></text>
      <text x="80" y="247"><tspan class="prp">edit</tspan><tspan class="txt">: </tspan><tspan class="str">"gemini-nano-banana-2.1"</tspan><tspan class="txt">, </tspan><tspan class="prp">svg</tspan><tspan class="txt">: </tspan><tspan class="str">"recraft-v4.1"</tspan><tspan class="txt"> });</tspan></text>
    </g>

    <g class="stage-c">
      <text x="64" y="266" class="cmt">// 3. Anamorphic Cinema + Native Lip-Synced Persian Voice</text>
      <text x="64" y="285"><tspan class="kw">await</tspan> <tspan class="txt">nvx.</tspan><tspan class="fn">direct</tspan><tspan class="txt">({ </tspan><tspan class="prp">cinema</tspan><tspan class="txt">: [</tspan><tspan class="str">"google-veo-3.1"</tspan><tspan class="txt">, </tspan><tspan class="str">"kling-o1"</tspan><tspan class="txt">],</tspan></text>
      <text x="80" y="304"><tspan class="prp">physics</tspan><tspan class="txt">: </tspan><tspan class="str">"flux-3-video"</tspan><tspan class="txt">, </tspan><tspan class="prp">tts</tspan><tspan class="txt">: </tspan><tspan class="str">"navidix-persian-tts"</tspan><tspan class="txt"> });</tspan></text>
    </g>
    <rect x="468" y="292" width="6.5" height="14" rx="1.2" fill="#38BDF8" class="cur-ide"/>
  </g>

  <!-- IDE Status Footer & Animated Compile Bar -->
  <path d="M 19 325 L 533 325 L 533 345 Q 533 357 521 357 L 31 357 Q 19 357 19 345 Z" fill="#0B1324"/>
  <line x1="18" y1="325" x2="534" y2="325" stroke="#223352" stroke-width="1"/>
  <rect x="28" y="325" width="220" height="2" fill="url(#progGrad)">
    <animate attributeName="width" values="60;492;60" dur="6s" repeatCount="indefinite"/>
  </rect>
  <circle cx="34" cy="341" r="3.6" fill="#34D399"/>
  <text x="45" y="345" class="mono" font-size="10.8" fill="#94B0DA">&#10003; 4/4 pipelines compiled &#183; OpenRouter live &#183; 4K 24fps master</text>


  <!-- ==================== RIGHT: LIVE NEURAL DAG (394px) ==================== -->
  <rect x="548" y="18" width="394" height="340" rx="13" fill="#0B1222" fill-opacity="0.92" stroke="#263859" stroke-width="1.2"/>
  <text x="566" y="42" class="mono" font-size="11" font-weight="700" fill="#BFD6FA" letter-spacing="0.9">MULTI-MODEL ROUTING DAG</text>
  <circle cx="884" cy="38" r="3.5" fill="#34D399">
    <animate attributeName="opacity" values="0.35;1;0.35" dur="1.8s" repeatCount="indefinite"/>
  </circle>
  <text x="926" y="42" text-anchor="end" class="mono" font-size="10.5" fill="#6EE7B7">LIVE</text>
  <line x1="548" y1="52" x2="942" y2="52" stroke="#223352" stroke-width="1"/>

  <!-- Neural Bezier Fibers (Input 630 -> 4 Engines 670..842 -> Output 876) -->
  <g fill="none" stroke-width="1.5">
    <path d="M 630 202 C 650 202, 648 98, 670 98" stroke="#38BDF8" stroke-opacity="0.45" class="wire"/>
    <path d="M 630 202 C 650 202, 650 166, 670 166" stroke="#34D399" stroke-opacity="0.45" class="wire"/>
    <path d="M 630 202 C 650 202, 650 234, 670 234" stroke="#FB7185" stroke-opacity="0.45" class="wire"/>
    <path d="M 630 202 C 650 202, 648 302, 670 302" stroke="#FBBF24" stroke-opacity="0.45" class="wire"/>

    <path d="M 842 98 C 862 98, 858 202, 876 202" stroke="#38BDF8" stroke-opacity="0.45" class="wire"/>
    <path d="M 842 166 C 860 166, 860 202, 876 202" stroke="#34D399" stroke-opacity="0.45" class="wire"/>
    <path d="M 842 234 C 860 234, 860 202, 876 202" stroke="#FB7185" stroke-opacity="0.45" class="wire"/>
    <path d="M 842 302 C 862 302, 858 202, 876 202" stroke="#FBBF24" stroke-opacity="0.45" class="wire"/>
  </g>

  <!-- Streaming Neural Photon Packets (Negative begin offsets so ALL are mid-flight at t=0!) -->
  <circle r="3.3" fill="#7DD3FC"><animateMotion dur="2.2s" begin="0s" repeatCount="indefinite" path="M 630 202 C 650 202, 648 98, 670 98"/></circle>
  <circle r="3.3" fill="#6EE7B7"><animateMotion dur="2.2s" begin="-0.55s" repeatCount="indefinite" path="M 630 202 C 650 202, 650 166, 670 166"/></circle>
  <circle r="3.3" fill="#FF6A5A"><animateMotion dur="2.2s" begin="-1.1s" repeatCount="indefinite" path="M 630 202 C 650 202, 650 234, 670 234"/></circle>
  <circle r="3.3" fill="#FDE047"><animateMotion dur="2.2s" begin="-1.65s" repeatCount="indefinite" path="M 630 202 C 650 202, 648 302, 670 302"/></circle>

  <circle r="3.3" fill="#7DD3FC"><animateMotion dur="2.2s" begin="-1.1s" repeatCount="indefinite" path="M 842 98 C 862 98, 858 202, 876 202"/></circle>
  <circle r="3.3" fill="#6EE7B7"><animateMotion dur="2.2s" begin="-1.65s" repeatCount="indefinite" path="M 842 166 C 860 166, 860 202, 876 202"/></circle>
  <circle r="3.3" fill="#FF6A5A"><animateMotion dur="2.2s" begin="-0.35s" repeatCount="indefinite" path="M 842 234 C 860 234, 860 202, 876 202"/></circle>
  <circle r="3.3" fill="#FDE047"><animateMotion dur="2.2s" begin="-0.9s" repeatCount="indefinite" path="M 842 302 C 862 302, 858 202, 876 202"/></circle>

  <!-- Source Node: IDEA / PROMPT -->
  <g transform="translate(560, 173)">
    <rect x="0" y="0" width="70" height="58" rx="11" fill="#1A1121" stroke="#E3202A" stroke-width="1.4"/>
    <text x="35" y="25" text-anchor="middle" class="mono" font-size="10.2" font-weight="700" fill="#FF7B73">PROMPT</text>
    <text x="35" y="44" text-anchor="middle" class="fa" font-size="12" font-weight="700" fill="#FFFFFF">$(Esc $D.dag_input_fa)</text>
  </g>

  <!-- Engine Node 1: LLM & Code (172px wide for generous breathing room) -->
  <g transform="translate(670, 72)">
    <rect x="0" y="0" width="172" height="52" rx="10" fill="#101D36" stroke="#2B6CFF" stroke-width="1.2"/>
    <text x="12" y="21" class="sans" font-size="12" font-weight="700" fill="#E0EEFF">LLM &amp; Agentic Code</text>
    <text x="12" y="38" class="mono" font-size="9.7" fill="#7DD3FC">Sonnet 5.5 &#183; Astra &#183; Argon</text>
  </g>

  <!-- Engine Node 2: Image & Vector -->
  <g transform="translate(670, 140)">
    <rect x="0" y="0" width="172" height="52" rx="10" fill="#0E2329" stroke="#10B981" stroke-width="1.2"/>
    <text x="12" y="21" class="sans" font-size="12" font-weight="700" fill="#D1FAE5">Studio Image &amp; SVG</text>
    <text x="12" y="38" class="mono" font-size="9.7" fill="#6EE7B7">Flux 3 &#183; Nano Banana 2.1</text>
  </g>

  <!-- Engine Node 3: Cinema Video -->
  <g transform="translate(670, 208)">
    <rect x="0" y="0" width="172" height="52" rx="10" fill="#231220" stroke="#E3202A" stroke-width="1.2"/>
    <text x="12" y="21" class="sans" font-size="12" font-weight="700" fill="#FFE4E6">Cinema &amp; Physics</text>
    <text x="12" y="38" class="mono" font-size="9.7" fill="#FDA4AF">Veo 3.1 &#183; Flux 3 &#183; Kling O1</text>
  </g>

  <!-- Engine Node 4: Persian Audio -->
  <g transform="translate(670, 276)">
    <rect x="0" y="0" width="172" height="52" rx="10" fill="#231D12" stroke="#F59E0B" stroke-width="1.2"/>
    <text x="12" y="21" class="sans" font-size="12" font-weight="700" fill="#FEF3C7">Persian Voice &amp; SFX</text>
    <text x="12" y="38" class="mono" font-size="9.7" fill="#FDE047">Navidix TTS &#183; Voice Clone</text>
  </g>

  <!-- Output Master Node: 4K FRAME -->
  <g transform="translate(876, 169)">
    <rect x="-3" y="-3" width="58" height="72" rx="13" fill="none" stroke="#38BDF8" stroke-opacity="0.4" stroke-width="1.5">
      <animate attributeName="stroke-opacity" values="0.2;0.85;0.2" dur="2.2s" repeatCount="indefinite"/>
    </rect>
    <rect x="0" y="0" width="52" height="66" rx="11" fill="#122342" stroke="#38BDF8" stroke-width="1.4"/>
    <text x="26" y="26" text-anchor="middle" class="mono" font-size="12" font-weight="800" fill="#8FDBFF">4K</text>
    <text x="26" y="47" text-anchor="middle" class="fa" font-size="12" font-weight="700" fill="#FFFFFF">$(Esc $D.dag_output_fa)</text>
  </g>
</svg>
"@
Save-Svg "terminal-pipeline.svg" $termSvg


# ==============================================================================
# 4. STUDIO ARCHITECTURE & ENGINEERING STACK (960 x 324)
# ==============================================================================
$archSvg = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 324" width="960" height="324" role="img" aria-label="Navidix Architecture and Engineering Stack">
  <defs>
    <linearGradient id="archBg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#192640"/>
      <stop offset="100%" stop-color="#090E1B"/>
    </linearGradient>
    <linearGradient id="cardGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#131E35"/>
      <stop offset="100%" stop-color="#0B1120"/>
    </linearGradient>
    <linearGradient id="topHairline" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#E3202A"/>
      <stop offset="60%" stop-color="#2B6CFF"/>
      <stop offset="100%" stop-color="#2B6CFF" stop-opacity="0"/>
    </linearGradient>
  </defs>

  <style><![CDATA[
    .sans { font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, 'Inter', Roboto, sans-serif; }
    .fa   { font-family: 'Estedad', 'Vazirmatn', 'Segoe UI', Tahoma, sans-serif; }
    .mono { font-family: 'JetBrains Mono', 'Cascadia Code', 'Fira Code', Consolas, monospace; }
  ]]></style>

  <rect x="2" y="2" width="956" height="320" rx="18" fill="url(#archBg)" stroke="#293B5C" stroke-width="1.4"/>

  <text x="24" y="33" class="mono" font-size="11.5" font-weight="700" fill="#9CC2F5" letter-spacing="1.2">02 &#183; STUDIO TRACKS &amp; FULL-STACK ARCHITECTURE</text>
  <text x="936" y="33" text-anchor="end" class="fa" font-size="13" font-weight="600" fill="#FF7B73">$(Esc $D.less_talk_fa)  &#183;  LESS TALK, MORE BUILDING</text>

  <!-- Card 1: Cinematic Documentaries -->
  <g transform="translate(20, 48)">
    <rect x="0" y="0" width="220" height="164" rx="13" fill="url(#cardGrad)" stroke="#273A5C" stroke-width="1.2"/>
    <rect x="14" y="0.5" width="130" height="2" fill="url(#topHairline)"/>
    <g transform="translate(26, 28)">
      <circle cx="0" cy="0" r="13" fill="#23121E" stroke="#E3202A" stroke-width="1.3"/>
      <g>
        <animateTransform attributeName="transform" type="rotate" from="0 0 0" to="360 0 0" dur="12s" repeatCount="indefinite"/>
        <circle cx="0" cy="0" r="8" fill="none" stroke="#FF6A5A" stroke-width="1.3" stroke-dasharray="3 4"/>
      </g>
      <circle cx="0" cy="0" r="2.5" fill="#FFFFFF"/>
    </g>
    <text x="48" y="33" class="mono" font-size="10.5" font-weight="700" fill="#FF7B73">01 &#183; CINEMA</text>
    <text x="16" y="64" class="sans" font-size="15" font-weight="700" fill="#FFFFFF">Science &amp; Tech Docs</text>
    <text x="16" y="87" class="sans" font-size="12.2" fill="#9EB3D6">Cinematic short documentaries</text>
    <text x="16" y="105" class="sans" font-size="12.2" fill="#9EB3D6">on physics, space, history &amp;</text>
    <text x="16" y="123" class="sans" font-size="12.2" fill="#9EB3D6">deep-tech in Persian.</text>
    <rect x="16" y="135" width="124" height="20" rx="6" fill="#1A1221" stroke="#4D2230" stroke-width="1"/>
    <text x="24" y="149" class="mono" font-size="9.8" fill="#FDA4AF">ANAMORPHIC &#183; 24FPS</text>
  </g>

  <!-- Card 2: Navidix AI Gateway -->
  <g transform="translate(253, 48)">
    <rect x="0" y="0" width="220" height="164" rx="13" fill="url(#cardGrad)" stroke="#273A5C" stroke-width="1.2"/>
    <rect x="14" y="0.5" width="130" height="2" fill="url(#topHairline)"/>
    <g transform="translate(26, 28)">
      <polygon points="0,-13 11.2,-6.5 11.2,6.5 0,13 -11.2,6.5 -11.2,-6.5" fill="#10203D" stroke="#2B6CFF" stroke-width="1.4"/>
      <circle cx="0" cy="0" r="3.8" fill="#38BDF8">
        <animate attributeName="r" values="2.5;4.8;2.5" dur="2s" repeatCount="indefinite"/>
      </circle>
    </g>
    <text x="48" y="33" class="mono" font-size="10.5" font-weight="700" fill="#7DD3FC">02 &#183; AI GATEWAY</text>
    <text x="16" y="64" class="sans" font-size="15" font-weight="700" fill="#FFFFFF">444+ Unified Models</text>
    <text x="16" y="87" class="sans" font-size="12.2" fill="#9EB3D6">Full-stack studio router for</text>
    <text x="16" y="105" class="sans" font-size="12.2" fill="#9EB3D6">LLM, code, studio photo, SVG,</text>
    <text x="16" y="123" class="sans" font-size="12.2" fill="#9EB3D6">cinema video &amp; Persian TTS.</text>
    <rect x="16" y="135" width="136" height="20" rx="6" fill="#0F1F3A" stroke="#25487F" stroke-width="1"/>
    <text x="24" y="149" class="mono" font-size="9.8" fill="#93C5FD">DJANGO &#183; OPENROUTER</text>
  </g>

  <!-- Card 3: Practical AI Curriculum -->
  <g transform="translate(487, 48)">
    <rect x="0" y="0" width="220" height="164" rx="13" fill="url(#cardGrad)" stroke="#273A5C" stroke-width="1.2"/>
    <rect x="14" y="0.5" width="130" height="2" fill="url(#topHairline)"/>
    <g transform="translate(26, 28)">
      <circle cx="0" cy="0" r="13" fill="#0E2427" stroke="#10B981" stroke-width="1.3"/>
      <text x="0" y="4" text-anchor="middle" class="mono" font-size="10.5" font-weight="700" fill="#6EE7B7">&lt;/&gt;</text>
    </g>
    <text x="48" y="33" class="mono" font-size="10.5" font-weight="700" fill="#6EE7B7">03 &#183; CURRICULUM</text>
    <text x="16" y="64" class="sans" font-size="15" font-weight="700" fill="#FFFFFF">Production Workflows</text>
    <text x="16" y="87" class="sans" font-size="12.2" fill="#9EB3D6">Field-tested prompt systems,</text>
    <text x="16" y="105" class="sans" font-size="12.2" fill="#9EB3D6">character consistency &amp; real</text>
    <text x="16" y="123" class="sans" font-size="12.2" fill="#9EB3D6">multi-model pipelines.</text>
    <rect x="16" y="135" width="136" height="20" rx="6" fill="#0E2424" stroke="#1D5B4B" stroke-width="1"/>
    <text x="24" y="149" class="mono" font-size="9.8" fill="#6EE7B7">56 INTERACTIVE PAGES</text>
  </g>

  <!-- Card 4: Spatial & Motion Web -->
  <g transform="translate(720, 48)">
    <rect x="0" y="0" width="220" height="164" rx="13" fill="url(#cardGrad)" stroke="#273A5C" stroke-width="1.2"/>
    <rect x="14" y="0.5" width="130" height="2" fill="url(#topHairline)"/>
    <g transform="translate(26, 28)">
      <circle cx="0" cy="0" r="13" fill="#1B1633" stroke="#8B5CF6" stroke-width="1.3"/>
      <g>
        <animateTransform attributeName="transform" type="rotate" from="360 0 0" to="0 0 0" dur="14s" repeatCount="indefinite"/>
        <rect x="-5.5" y="-5.5" width="11" height="11" rx="2" fill="none" stroke="#C4B5FD" stroke-width="1.3"/>
      </g>
    </g>
    <text x="48" y="33" class="mono" font-size="10.5" font-weight="700" fill="#C4B5FD">04 &#183; INTERACTIVE</text>
    <text x="16" y="64" class="sans" font-size="15" font-weight="700" fill="#FFFFFF">3D &amp; Motion Systems</text>
    <text x="16" y="87" class="sans" font-size="12.2" fill="#9EB3D6">Three.js WebGL stages, GSAP</text>
    <text x="16" y="105" class="sans" font-size="12.2" fill="#9EB3D6">choreography, bespoke RTL</text>
    <text x="16" y="123" class="sans" font-size="12.2" fill="#9EB3D6">Persian typography &amp; SVG UI.</text>
    <rect x="16" y="135" width="128" height="20" rx="6" fill="#1A1530" stroke="#4C357D" stroke-width="1"/>
    <text x="24" y="149" class="mono" font-size="9.8" fill="#DDD6FE">THREE.JS &#183; WEBGL</text>
  </g>

  <!-- Bottom Engineering Stack Ribbon -->
  <rect x="20" y="226" width="920" height="78" rx="13" fill="#0A101E" stroke="#253757" stroke-width="1.2"/>
  <text x="36" y="248" class="mono" font-size="10.2" font-weight="700" fill="#7D97C2" letter-spacing="1.1">CORE ENGINEERING TOOLCHAIN &amp; RUNTIME</text>

  <g transform="translate(36, 260)" class="mono" font-size="11" font-weight="600">
    <g transform="translate(0,0)">
      <rect width="124" height="28" rx="7" fill="#121E36" stroke="#2D4A7C"/>
      <circle cx="14" cy="14" r="3.2" fill="#38BDF8"/>
      <text x="24" y="18" fill="#E2EEFF">Python&#183;Django</text>
    </g>
    <g transform="translate(132,0)">
      <rect width="118" height="28" rx="7" fill="#121E36" stroke="#2D4A7C"/>
      <circle cx="14" cy="14" r="3.2" fill="#FACC15"/>
      <text x="24" y="18" fill="#E2EEFF">JS &#183; ES2026</text>
    </g>
    <g transform="translate(258,0)">
      <rect width="132" height="28" rx="7" fill="#121E36" stroke="#2D4A7C"/>
      <circle cx="14" cy="14" r="3.2" fill="#A78BFA"/>
      <text x="24" y="18" fill="#E2EEFF">Three.js&#183;WebGL</text>
    </g>
    <g transform="translate(398,0)">
      <rect width="122" height="28" rx="7" fill="#121E36" stroke="#2D4A7C"/>
      <circle cx="14" cy="14" r="3.2" fill="#34D399"/>
      <text x="24" y="18" fill="#E2EEFF">GSAP &#183; SMIL</text>
    </g>
    <g transform="translate(528,0)">
      <rect width="124" height="28" rx="7" fill="#121E36" stroke="#2D4A7C"/>
      <circle cx="14" cy="14" r="3.2" fill="#E3202A"/>
      <text x="24" y="18" fill="#E2EEFF">OpenRouter</text>
    </g>
    <g transform="translate(660,0)">
      <rect width="112" height="28" rx="7" fill="#121E36" stroke="#2D4A7C"/>
      <circle cx="14" cy="14" r="3.2" fill="#FB7185"/>
      <text x="24" y="18" fill="#E2EEFF">HTML5&#183;CSS3</text>
    </g>
    <g transform="translate(780,0)">
      <rect width="108" height="28" rx="7" fill="#121E36" stroke="#2D4A7C"/>
      <circle cx="14" cy="14" r="3.2" fill="#60A5FA"/>
      <text x="24" y="18" fill="#E2EEFF">Docker&#183;Git</text>
    </g>
  </g>
</svg>
"@
Save-Svg "architecture-stack.svg" $archSvg


# ==============================================================================
# 5. STUDIO PULSE MATRIX & 2026 BENCHMARK TELEMETRY (960 x 236)
# ==============================================================================
$gridCells = New-Object System.Text.StringBuilder
$palette = @("#131E34", "#183059", "#1E4B8F", "#2B6CFF", "#E3202A", "#FF5E57")
for ($col = 0; $col -lt 25; $col++) {
    for ($row = 0; $row -lt 5; $row++) {
        $cx = 36 + ($col * 17)
        $cy = 72 + ($row * 17)
        $wave = [Math]::Sin(($col * 0.55) + ($row * 1.15))
        $boost = ($col / 24.0) * 3.4
        $lvl = [int][Math]::Floor([Math]::Max(0, [Math]::Min(5, ($wave + 1.15) * 1.1 + $boost - 1.1)))
        $fill = $palette[$lvl]
        if ($lvl -ge 4 -and (($col + $row) % 2 -eq 0)) {
            $dur = [Math]::Round(1.8 + (($col % 4) * 0.45), 2)
            [void]$gridCells.AppendLine("    <rect x=`"$cx`" y=`"$cy`" width=`"12.5`" height=`"12.5`" rx=`"3`" fill=`"$fill`"><animate attributeName=`"opacity`" values=`"0.62;1;0.62`" dur=`"${dur}s`" repeatCount=`"indefinite`"/></rect>")
        } else {
            [void]$gridCells.AppendLine("    <rect x=`"$cx`" y=`"$cy`" width=`"12.5`" height=`"12.5`" rx=`"3`" fill=`"$fill`"/>")
        }
    }
}

$benchRows = New-Object System.Text.StringBuilder
$bi = 0
foreach ($bm in $D.benchmarks) {
    $gradId = "bmGrad$bi"
    [void]$benchRows.AppendLine("    <linearGradient id=`"$gradId`" x1=`"0%`" y1=`"0%`" x2=`"100%`" y2=`"0%`"><stop offset=`"0%`" stop-color=`"$($bm.color1)`"/><stop offset=`"100%`" stop-color=`"$($bm.color2)`"/></linearGradient>")
    $bi++
}

$benchDraw = New-Object System.Text.StringBuilder
$bi = 0
foreach ($bm in $D.benchmarks) {
    $by = 62 + ($bi * 31)
    $targetW = [Math]::Round(($bm.pct / 100.0) * 402, 1)
    $gradId = "bmGrad$bi"
    [void]$benchDraw.AppendLine(@"
  <g transform="translate(518, $by)">
    <text x="0" y="11" class="sans" font-size="11.8" font-weight="700" fill="#E6F0FF">$(Esc $bm.name) <tspan class="mono" font-size="9.8" font-weight="400" fill="#829BC4">&#183; $(Esc $bm.tag)</tspan></text>
    <text x="402" y="11" text-anchor="end" class="mono" font-size="11.2" font-weight="700" fill="$($bm.color2)">$(Esc $bm.score)</text>
    <rect x="0" y="16" width="402" height="6.5" rx="3.2" fill="#121C31"/>
    <rect x="0" y="16" width="$targetW" height="6.5" rx="3.2" fill="url(#$gradId)">
      <animate attributeName="opacity" values="0.82;1;0.82" dur="$(2.2 + ($bi * 0.35))s" repeatCount="indefinite"/>
    </rect>
  </g>
"@)
    $bi++
}

$pulseSvg = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 236" width="960" height="236" role="img" aria-label="Navidix Studio Pulse and 2026 AI Index">
  <defs>
    <linearGradient id="pulseBg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#17233B"/>
      <stop offset="100%" stop-color="#090E1A"/>
    </linearGradient>
    <linearGradient id="scanLaser" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#38BDF8" stop-opacity="0"/>
      <stop offset="50%" stop-color="#8FDBFF" stop-opacity="0.55"/>
      <stop offset="100%" stop-color="#E3202A" stop-opacity="0"/>
    </linearGradient>
$($benchRows.ToString())
  </defs>

  <style><![CDATA[
    .sans { font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, 'Inter', Roboto, sans-serif; }
    .mono { font-family: 'JetBrains Mono', 'Cascadia Code', 'Fira Code', Consolas, monospace; }
  ]]></style>

  <rect x="2" y="2" width="956" height="232" rx="18" fill="url(#pulseBg)" stroke="#293B5C" stroke-width="1.4"/>

  <rect x="18" y="18" width="466" height="200" rx="13" fill="#0B1222" stroke="#243656" stroke-width="1.2"/>
  <text x="36" y="42" class="mono" font-size="11" font-weight="700" fill="#B9D5FF" letter-spacing="0.9">ECOSYSTEM SPRINT &amp; COMMIT MATRIX</text>
  <text x="466" y="42" text-anchor="end" class="mono" font-size="10.2" fill="#FF7B73">&#9679; ACTIVE SPRINT</text>
  <line x1="18" y1="53" x2="484" y2="53" stroke="#1E2E4A" stroke-width="1"/>

  <g>
$($gridCells.ToString())
  </g>

  <rect x="34" y="68" width="22" height="90" fill="url(#scanLaser)">
    <animate attributeName="x" values="32;440;32" dur="6.8s" repeatCount="indefinite"/>
  </rect>

  <text x="36" y="184" class="mono" font-size="10.4" fill="#8EA7CE">FE: <tspan fill="#FFFFFF" font-weight="700">1,042</tspan>  &#183;  AI-GW: <tspan fill="#FFFFFF" font-weight="700">413</tspan>  &#183;  CORE: <tspan fill="#FFFFFF" font-weight="700">349</tspan>  commits</text>
  <g transform="translate(362, 174)">
    <text x="-8" y="10" text-anchor="end" class="mono" font-size="9.5" fill="#6F88B0">LOAD</text>
    <rect x="0" y="1" width="9" height="9" rx="2" fill="#131E34"/>
    <rect x="13" y="1" width="9" height="9" rx="2" fill="#1E4B8F"/>
    <rect x="26" y="1" width="9" height="9" rx="2" fill="#2B6CFF"/>
    <rect x="39" y="1" width="9" height="9" rx="2" fill="#E3202A"/>
    <rect x="52" y="1" width="9" height="9" rx="2" fill="#FF5E57"/>
  </g>
  <text x="36" y="203" class="mono" font-size="10" fill="#647FA8">23 Deep-Dive Benchmarks &#183; 56 Web Lessons &#183; 93 NVX Modules</text>

  <rect x="500" y="18" width="442" height="200" rx="13" fill="#0B1222" stroke="#243656" stroke-width="1.2"/>
  <text x="518" y="42" class="mono" font-size="11" font-weight="700" fill="#B9D5FF" letter-spacing="0.9">NAVIDIX 2026 FLAGSHIP AI INDEX</text>
  <text x="924" y="42" text-anchor="end" class="mono" font-size="10.2" fill="#7DD3FC">VERIFIED &#183; OCT 2026</text>
  <line x1="500" y1="53" x2="942" y2="53" stroke="#1E2E4A" stroke-width="1"/>

$($benchDraw.ToString())
</svg>
"@
Save-Svg "telemetry-pulse.svg" $pulseSvg


# ==============================================================================
# 6. ANAMORPHIC HORIZON FOOTER & STUDIO CREED (960 x 110)
# ==============================================================================
$footerSvg = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 110" width="960" height="110" role="img" aria-label="Build Learn Publish - Navidix Studio">
  <defs>
    <linearGradient id="footBg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#16223A"/>
      <stop offset="50%" stop-color="#0D1526"/>
      <stop offset="100%" stop-color="#171222"/>
    </linearGradient>
    <linearGradient id="waveRed" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#E3202A" stop-opacity="0"/>
      <stop offset="35%" stop-color="#E3202A" stop-opacity="0.65"/>
      <stop offset="70%" stop-color="#FF6A5A" stop-opacity="0.45"/>
      <stop offset="100%" stop-color="#E3202A" stop-opacity="0"/>
    </linearGradient>
    <linearGradient id="waveBlue" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#2B6CFF" stop-opacity="0"/>
      <stop offset="30%" stop-color="#2B6CFF" stop-opacity="0.55"/>
      <stop offset="68%" stop-color="#8FDBFF" stop-opacity="0.65"/>
      <stop offset="100%" stop-color="#2B6CFF" stop-opacity="0"/>
    </linearGradient>
    <clipPath id="footClip">
      <rect x="2" y="2" width="956" height="106" rx="16"/>
    </clipPath>
  </defs>

  <style><![CDATA[
    .sans { font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, 'Inter', Roboto, sans-serif; }
    .fa   { font-family: 'Estedad', 'Vazirmatn', 'Segoe UI', Tahoma, sans-serif; }
    .mono { font-family: 'JetBrains Mono', 'Cascadia Code', 'Fira Code', Consolas, monospace; }
  ]]></style>

  <g clip-path="url(#footClip)">
    <rect x="2" y="2" width="956" height="106" fill="url(#footBg)"/>
    <path d="M -200 88 Q 40 62, 280 86 T 760 84 T 1240 88" fill="none" stroke="url(#waveBlue)" stroke-width="2">
      <animateTransform attributeName="transform" type="translate" values="0,0; -180,0; 0,0" dur="9s" repeatCount="indefinite"/>
    </path>
    <path d="M -120 94 Q 160 112, 420 88 T 940 92 T 1360 88" fill="none" stroke="url(#waveRed)" stroke-width="2">
      <animateTransform attributeName="transform" type="translate" values="0,0; 160,0; 0,0" dur="7.5s" repeatCount="indefinite"/>
    </path>
  </g>

  <rect x="2" y="2" width="956" height="106" rx="16" fill="none" stroke="#293B5C" stroke-width="1.4"/>

  <image href="data:image/webp;base64,$MarkB64" x="34" y="27" width="54" height="54" preserveAspectRatio="xMidYMid meet"/>

  <text x="498" y="48" text-anchor="middle" class="sans" font-size="15.5" font-weight="800" fill="#FFFFFF" letter-spacing="1.8">
    $(Esc $D.creed_en)   <tspan fill="#E3202A">&#183;</tspan>   <tspan class="fa" font-size="16" letter-spacing="0" fill="#DCE9FF">$(Esc $D.creed_fa)</tspan>
  </text>
  <text x="498" y="74" text-anchor="middle" class="mono" font-size="11" fill="#89A3CC" letter-spacing="0.9">
    ENGINEERED BY MOHAMMAD NAVIDI  &#183;  NAVIDIXSTUDIO.COM  &#183;  CODE-DRIVEN SVG ENGINE
  </text>
</svg>
"@
Save-Svg "footer-creed.svg" $footerSvg

Write-Host "`nAll Navidix Studio animated profile SVGs generated and XML-validated successfully!"
