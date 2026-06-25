#!/usr/bin/env bash
#
# run.sh — Ejecuta la evaluación de Promptfoo para el chatbot educativo.
#
# Uso:
#   ./run.sh           # ejecuta promptfoo eval (serializado, respeta el rate limit)
#   ./run.sh view      # abre la interfaz web con los últimos resultados
#   ./run.sh html      # exporta los resultados a resultados.html
#
set -euo pipefail

# --- Configuración -----------------------------------------------------------

# Promptfoo se instaló con prefijo de usuario (~/.npm-global)
export PATH="$HOME/.npm-global/bin:$PATH"

# API Key de Gemini (puedes sobreescribirla exportándola antes de llamar al script)
export GEMINI_API_KEY="${GEMINI_API_KEY:-TU_API_KEY_AQUI}"

# Carpeta del proyecto (la del propio script)
cd "$(dirname "$0")"

# --- Comprobaciones ----------------------------------------------------------

if ! command -v promptfoo >/dev/null 2>&1; then
  echo "ERROR: no se encontró 'promptfoo' en el PATH." >&2
  echo "       Instálalo con: npm install -g promptfoo" >&2
  exit 1
fi

# --- Acciones ----------------------------------------------------------------

case "${1:-eval}" in
  eval)
    echo ">> Ejecutando promptfoo eval (serializado, pausa de 4s entre llamadas)..."
    promptfoo eval --no-cache -j 1 --delay 4000
    echo
    echo ">> Listo. Para ver los resultados en el navegador:  ./run.sh view"
    ;;
  view)
    echo ">> Abriendo la interfaz web (Ctrl+C para cerrar)..."
    promptfoo view
    ;;
  html)
    echo ">> Exportando resultados a resultados.html..."
    promptfoo eval --no-cache -j 1 --delay 4000 -o resultados.html
    echo ">> Generado: $(pwd)/resultados.html"
    ;;
  *)
    echo "Uso: ./run.sh [eval|view|html]" >&2
    exit 1
    ;;
esac
