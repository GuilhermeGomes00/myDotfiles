// ==UserScript==
// @name         JSON Formatter simples
// @match        *://*/*
// @run-at       document-end
// @noframes
// ==/UserScript==

// Só altera documentos servidos com um tipo MIME de JSON.
const mime = document.contentType.toLowerCase();
if (mime === "application/json" || mime.endsWith("+json")) {
    const original = document.body?.textContent ?? "";
    if (original && original.length <= 2_000_000) {
        try {
            const formatted = JSON.stringify(JSON.parse(original), null, 2);
            const pretty = document.createElement("pre");
            pretty.textContent = formatted;
            pretty.style.cssText = "font: 13px/1.5 monospace; white-space: pre-wrap; overflow-wrap: anywhere";

            // O conteúdo recebido continua acessível, sem modificar sua versão original.
            const details = document.createElement("details");
            const summary = document.createElement("summary");
            summary.textContent = "JSON original";
            const raw = document.createElement("pre");
            raw.textContent = original;
            details.append(summary, raw);
            document.body.replaceChildren(pretty, details);
        } catch (error) {
            // JSON inválido permanece como recebido.
        }
    }
}
