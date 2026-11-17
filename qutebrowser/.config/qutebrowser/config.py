# =========================
# SEARCH
# =========================
# Carrega configurações feitas pelo :set antes das opções deste arquivo.
# Isso mantém, por exemplo, o Google configurado em autoconfig.yml.
config.load_autoconfig()


# =========================
# APPEARANCE
# =========================

# Fonte
c.fonts.default_family = "monospace"
c.fonts.default_size = "10pt"

# -------- ABAS --------


# Fundo da barra
c.colors.tabs.bar.bg = "#0d0d0d"

# Abas inativas
c.colors.tabs.odd.bg = "#161616"
c.colors.tabs.odd.fg = "#8a8a8a"

c.colors.tabs.even.bg = "#161616"
c.colors.tabs.even.fg = "#8a8a8a"

# Aba selecionada
c.colors.tabs.selected.odd.bg = "#c94f2c"
c.colors.tabs.selected.odd.fg = "#ffffff"

c.colors.tabs.selected.even.bg = "#c94f2c"
c.colors.tabs.selected.even.fg = "#ffffff"

# Indicador de carregamento
c.colors.tabs.indicator.start = "#ff5f38"
c.colors.tabs.indicator.stop = "#ff9e64"

# =========================
# TABS
# =========================
# Espaçamento
c.tabs.padding = {
    "top": 6,
    "bottom": 6,
    "left": 10,
    "right": 10,
}

# Esconde a barra se tiver apenas uma aba
c.tabs.show = "multiple"


# -------- STATUS BAR --------

c.colors.statusbar.normal.bg = "#0d0d0d"
c.colors.statusbar.normal.fg = "#d8d8d8"

# URL
c.colors.statusbar.url.fg = "#d8d8d8"
c.colors.statusbar.url.success.https.fg = "#ff9e64"

# Statusbar mais limpa
c.statusbar.widgets = [
    "keypress",
    "search_match",
    "url",
    "scroll",
    "tabs",
]


# -------- HINTS --------

# As letras que aparecem quando você aperta "f"
c.colors.hints.bg = "#ff6b35"
c.colors.hints.fg = "#0d0d0d"

c.colors.hints.match.fg = "#ffffff"


# -------- JANELA --------

# Remove decoração do sistema
c.window.hide_decoration = True

# =========================
# DARK MODE
# =========================

# Diz aos sites que preferimos o tema escuro nativo deles
c.colors.webpage.preferred_color_scheme = "dark"

# Força dark mode inclusive em sites que não possuem tema escuro
c.colors.webpage.darkmode.enabled = True

# Evita estragar imagens/fotos
c.colors.webpage.darkmode.policy.images = "smart"
# Alterna o dark mode forçado
config.bind(",d", "config-cycle colors.webpage.darkmode.enabled true false")

# =========================
# ADBLOCK
# =========================

# Ativa o bloqueador
c.content.blocking.enabled = True

# Usa o bloqueador ABP do Brave + bloqueio por hosts
c.content.blocking.method = "both"

# As listas padrão do qutebrowser são EasyList, EasyPrivacy e StevenBlack hosts.
# ,a alterna apenas o host atual, salva a exceção no autoconfig.yml e recarrega.


# =========================
# VIDEO
# =========================
def _video_rate(delta=None):
    """Ajusta vídeos HTML5 em passos de 0,25x; None restaura 1x."""
    rate = (
        "1"
        if delta is None
        else f"Math.min(16,Math.max(0.25,Math.round((video.playbackRate+({delta}))*100)/100))"
    )
    return (
        "jseval (function(){"
        'let videos=[...document.querySelectorAll("video")];'
        f"videos.forEach(video=>video.playbackRate={rate});"
        'return videos.length?"Velocidade: "+'
        "[...new Set(videos.map(video=>video.playbackRate))]"
        '.map(rate=>rate+"x").join(", ")+" ("+videos.length+" vídeo(s))"'
        ':"Nenhum vídeo HTML5 nesta página";'
        "})()"
    )


# =========================
# START PAGE
# =========================

# Página aberta ao iniciar o qutebrowser
c.url.start_pages = ["https://www.8bitdash.com/dashboard"]

# Página aberta ao criar uma nova aba sem URL
c.url.default_page = "https://www.8bitdash.com/dashboard"


# =========================
# QUICK SITES
# =========================

# ,s = sites
config.bind(",sy", "quickmark-load -t yt")
config.bind(",sz", "quickmark-load -t zap")
config.bind(",sg", "quickmark-load -t gmail")
config.bind(",so", "quickmark-load -t outlook")
config.bind(",sd", "quickmark-load -t discord")

config.bind(",sc", "quickmark-load -t gpt")
config.bind(",scl", "quickmark-load -t claude")
config.bind(",sge", "quickmark-load -t gemini")

config.bind(",sa", "quickmark-load -t 5etools")
config.bind(",sv", "quickmark-load -t velvet")
config.bind(",su", "quickmark-load -t udemy")
config.bind(",sn", "quickmark-load -t notion")

config.bind(",sr", "quickmark-load -t RDA")


# =========================
# TRANSLATION
# =========================
# O userscript local monta a URL do Google Tradutor com codificação segura.
# A tradução abre sempre em uma nova aba.


# =========================
# DOWNLOADS
# =========================
# Mantém a confirmação de destino e as proteções de download padrão.
c.downloads.location.directory = "~/Downloads"


# =========================
# PRIVACY
# =========================
# Evita reprodução automática; vídeos continuam disponíveis ao clicar em play.
c.content.autoplay = False
# Cookies, notificações, histórico e armazenamento persistente mantêm os
# padrões do qutebrowser para preservar compatibilidade.


# =========================
# KEYBINDS
# =========================
config.bind(
    ",a",
    "config-cycle -p -u *://{url:host}/* content.blocking.enabled false true ;; reload",
)

# ,+ aumenta 0,25x; ,= restaura 1x; ,- diminui 0,25x.
config.bind(",+", _video_rate(0.25))
config.bind(",=", _video_rate())
config.bind(",-", _video_rate(-0.25))

config.bind(",m", "spawn mpv {url}")
config.bind(",M", "hint links spawn mpv {hint-url}")

config.bind(",tp", "spawn --userscript qute-translate page")
config.bind(",ts", "spawn --userscript qute-translate selection")
