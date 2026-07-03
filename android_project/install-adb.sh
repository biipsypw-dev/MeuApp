#!/bin/bash
#=================================================
# INSTALL-ADB.SH — Instala o APK no celular
# Uso no Termux: bash install-adb.sh
#=================================================

APK="./dist/app.apk"

echo ""
echo "========================================"
echo "  Instalador do APK"
echo "========================================"
echo ""

#─────────────────────────────────────────────
# BLOCO 1 — Verifica se está no Termux
#─────────────────────────────────────────────
if [ -z "$TERMUX_VERSION" ]; then
    echo "⚠️  Este script foi feito para rodar dentro do Termux."
    echo "   Se estiver em outro Linux, instale o adb via:"
    echo "   sudo apt install adb"
    echo ""
fi

#─────────────────────────────────────────────
# BLOCO 2 — Instala o android-tools (adb)
#─────────────────────────────────────────────
echo "[1/4] Verificando adb..."
if ! command -v adb &> /dev/null; then
    echo "      adb não encontrado. Instalando android-tools..."
    pkg update -y
    pkg install android-tools -y
else
    echo "      adb já instalado: $(adb version | head -n 1)"
fi

#─────────────────────────────────────────────
# BLOCO 3 — Verifica se o APK existe
#─────────────────────────────────────────────
echo "[2/4] Verificando APK..."
if [ ! -f "$APK" ]; then
    echo "❌ APK não encontrado: $APK"
    echo "   Rode primeiro: ./build.sh"
    exit 1
fi

echo "      APK encontrado: $APK"

#─────────────────────────────────────────────
# BLOCO 4 — Escolhe modo de instalação
#─────────────────────────────────────────────
echo ""
echo "[3/4] Como deseja instalar?"
echo ""
echo "  1) Instalar no próprio celular (via termux-open)"
echo "  2) Instalar via USB/ADB em outro dispositivo"
echo ""
read -p "Opção [1-2]: " opcao

case "$opcao" in
    1)
        echo ""
        echo "[4/4] Abrindo instalador do Android..."
        termux-open "$APK"
        echo "✅ Toque em 'Instalar' na tela que abrir."
        ;;
    2)
        echo ""
        echo "[4/4] Verificando dispositivos ADB..."
        adb devices
        echo ""
        read -p "Pressione ENTER quando o dispositivo estiver conectado e autorizado..."
        echo ""
        echo "Instalando APK..."
        adb install -r "$APK"
        echo "✅ Instalação concluída."
        ;;
    *)
        echo "❌ Opção inválida."
        exit 1
        ;;
esac

echo ""
echo "========================================"
echo "  Pronto!"
echo "========================================"
echo ""
