#!/bin/bash

# =============================================================
# build.sh — Script de compilação do MeuApp
# Fluxo: XML → .flat → APK base + R.java → .class → .dex
#        → APK completo → assinado → Downloads
# =============================================================

# -------------------------------------------------------------
# CONFIGURAÇÕES DO PROJETO
# Variáveis centralizadas aqui para facilitar reuso em
# outros projetos — basta alterar esta seção.
# -------------------------------------------------------------

# Nome do pacote — deve ser IDÊNTICO ao do AndroidManifest.xml
PACKAGE="com.meuapp"

# Caminhos base
PROJECT_DIR="$HOME/meuapp"
SRC_DIR="$PROJECT_DIR/src"
RES_DIR="$PROJECT_DIR/res"
MANIFEST="$PROJECT_DIR/AndroidManifest.xml"

# Caminhos de saída intermediários e final
BUILD_DIR="$PROJECT_DIR/build"
FLAT_DIR="$BUILD_DIR/flat"        # recursos compilados pelo aapt2
GEN_DIR="$BUILD_DIR/gen"          # onde o R.java será gerado
CLASSES_DIR="$BUILD_DIR/classes"  # onde os .class compilados ficam
DEX_DIR="$BUILD_DIR/dex"          # onde o classes.dex fica
OUTPUT_DIR="$BUILD_DIR/output"    # APKs intermediário e final

# Android SDK
ANDROID_JAR="$HOME/Android/Sdk/platforms/android-34/android.jar"

# Nome do APK final
APK_NAME="MeuApp"

# Destino final do APK assinado
DOWNLOADS_DIR="$HOME/storage/downloads"

# -------------------------------------------------------------
# FUNÇÃO: imprimir mensagem colorida no terminal
# \e[1;32m = verde negrito, \e[1;31m = vermelho negrito
# \e[0m = reset da cor
# Isso ajuda a identificar visualmente cada etapa no terminal
# -------------------------------------------------------------
ok()   { echo -e "\e[1;32m[OK]\e[0m $1"; }
erro() { echo -e "\e[1;31m[ERRO]\e[0m $1"; exit 1; }
info() { echo -e "\e[1;34m[INFO]\e[0m $1"; }

# -------------------------------------------------------------
# FUNÇÃO: verificar se o comando anterior teve sucesso
# No shell, todo comando retorna um código: 0 = sucesso
# $? captura o código do último comando executado
# Se não for 0, algo deu errado — abortamos com mensagem clara
# -------------------------------------------------------------
checar() {
    if [ $? -ne 0 ]; then
        erro "$1"
    fi
}

# =============================================================
# INÍCIO DO BUILD
# =============================================================
info "Iniciando build do $APK_NAME..."
echo "-------------------------------------------"

# -------------------------------------------------------------
# PASSO 0 — Limpar build anterior
# Remove tudo da pasta build/ para garantir que não há
# arquivos antigos interferindo na compilação atual.
# -------------------------------------------------------------
info "Passo 0: Limpando build anterior..."
rm -rf "$BUILD_DIR"
mkdir -p "$FLAT_DIR" "$GEN_DIR" "$CLASSES_DIR" "$DEX_DIR" "$OUTPUT_DIR"
checar "Falha ao criar diretórios de build."
ok "Diretórios criados."

# -------------------------------------------------------------
# PASSO 1 — Compilar recursos com aapt2 compile
# O aapt2 lê cada arquivo XML da pasta res/ e converte
# para o formato binário .flat — um formato intermediário
# otimizado para a próxima etapa (link).
#
# --dir res/   = compila todos os recursos da pasta res/
# -o flat/     = salva os .flat nesta pasta
# -------------------------------------------------------------
info "Passo 1: Compilando recursos com aapt2..."
aapt2 compile \
    --dir "$RES_DIR" \
    -o "$FLAT_DIR"
checar "Falha no aapt2 compile. Verifique os arquivos em res/."
ok "Recursos compilados em .flat."

# -------------------------------------------------------------
# PASSO 2 — Linkar recursos com aapt2 link
# Une todos os .flat com o AndroidManifest.xml e o android.jar
# para gerar:
#   - APK base (contém recursos mas ainda sem código .dex)
#   - R.java (classe com os IDs de todos os recursos)
#
# --proto-format não é usado aqui pois usaremos dx (não r8/d8 proto)
# -o = APK base de saída
# --manifest = caminho do AndroidManifest.xml
# -I = android.jar para referência das classes do Android
# --java = onde gerar o R.java
# --auto-add-overlay = permite sobreposição de recursos
# -------------------------------------------------------------
info "Passo 2: Linkando recursos com aapt2..."
aapt2 link \
    -o "$OUTPUT_DIR/${APK_NAME}-base.apk" \
    --manifest "$MANIFEST" \
    -I "$ANDROID_JAR" \
    --java "$GEN_DIR" \
    --auto-add-overlay \
    "$FLAT_DIR"/*.flat
checar "Falha no aapt2 link. Verifique o AndroidManifest.xml e os recursos."
ok "APK base gerado e R.java criado."

# -------------------------------------------------------------
# PASSO 3 — Compilar Java com ecj
# O ecj lê todos os arquivos .java (seu código + R.java gerado)
# e compila para arquivos .class — o bytecode da JVM.
#
# -source 8 -target 8 = compatibilidade com Java 8
# -cp = classpath: onde encontrar classes externas (android.jar)
# -d = onde salvar os .class compilados
# -------------------------------------------------------------
info "Passo 3: Compilando Java com ecj (via dalvikvm direto)..."
dalvikvm -Xmx256m \
    -cp "$PREFIX/share/dex/ecj.jar" \
    org.eclipse.jdt.internal.compiler.batch.Main \
    -proc:none \
    -1.8 \
    -cp "$ANDROID_JAR" \
    -d "$CLASSES_DIR" \
    "$GEN_DIR/com/meuapp/R.java" \
	$(find "$SRC_DIR" -name "*.java")
checar "Falha na compilação Java. Verifique os arquivos .java."
ok "Arquivos .class gerados."

# -------------------------------------------------------------
# PASSO 4 — Converter .class para .dex
# -------------------------------------------------------------

if command -v dx >/dev/null 2>&1; then

    info "Passo 4: Convertendo .class para .dex com dx..."

    dx \
        --dex \
        --output="$DEX_DIR/classes.dex" \
        "$CLASSES_DIR"

elif command -v d8 >/dev/null 2>&1; then

    info "Passo 4: Convertendo .class para .dex com d8..."

    d8 \
        --lib "$ANDROID_JAR" \
        --output "$DEX_DIR" \
        $(find "$CLASSES_DIR" -name "*.class")

else

    erro "Nem dx nem d8 foram encontrados no PATH."

fi

checar "Falha na conversão para .dex."
ok "classes.dex gerado."

# -------------------------------------------------------------
# PASSO 5 — Montar APK completo
# O APK base gerado pelo aapt2 já tem os recursos.
# Agora precisamos adicionar o classes.dex dentro dele.
# O APK é tecnicamente um arquivo ZIP — usamos o zip para isso.
#
# Copiamos o APK base e adicionamos o .dex dentro dele.
# O classes.dex DEVE estar na raiz do APK.
# -------------------------------------------------------------
info "Passo 5: Montando APK completo..."
cp "$OUTPUT_DIR/${APK_NAME}-base.apk" "$OUTPUT_DIR/${APK_NAME}-unsigned.apk"
checar "Falha ao copiar APK base."

# Entramos na pasta do dex para que o zip adicione
# o classes.dex na RAIZ do APK, sem caminhos extras
cd "$DEX_DIR"
zip -j "$OUTPUT_DIR/${APK_NAME}-unsigned.apk" classes.dex
checar "Falha ao adicionar classes.dex no APK."
cd "$PROJECT_DIR"
ok "APK completo não assinado montado."

# -------------------------------------------------------------
# PASSO 5.5 — Alinhar APK com zipalign
#
# O Android recomenda que todo APK seja alinhado antes da
# assinatura. Isso melhora o carregamento dos recursos e evita
# rejeição em alguns dispositivos.
# -------------------------------------------------------------
info "Passo 5.5: Alinhando APK com zipalign..."

zipalign -f 4 \
    "$OUTPUT_DIR/${APK_NAME}-unsigned.apk" \
    "$OUTPUT_DIR/${APK_NAME}-aligned.apk"

checar "Falha no zipalign."

ok "APK alinhado."

# -------------------------------------------------------------
# PASSO 6 — Assinar o APK com apksigner
# O Android recusa instalar qualquer APK não assinado.
# A assinatura garante a identidade do desenvolvedor.
#
# Aqui usamos uma keystore de debug gerada automaticamente
# pelo keytool — ferramenta que vem junto com o Java.
#
# A keystore é gerada apenas uma vez e reutilizada.
# Em produção você usaria uma keystore própria e segura.
# -------------------------------------------------------------
info "Passo 6: Verificando keystore de debug..."

KEYSTORE="$HOME/.android/debug.keystore"

# Gera a keystore apenas se ainda não existir
if [ ! -f "$KEYSTORE" ]; then
    info "Keystore não encontrada. Gerando keystore de debug..."
    mkdir -p "$HOME/.android"
    keytool -genkeypair \
        -keystore "$KEYSTORE" \
        -storepass android \
        -alias androiddebugkey \
        -keypass android \
        -keyalg RSA \
        -keysize 2048 \
        -validity 10000 \
        -dname "CN=Android Debug,O=Android,C=US"
    checar "Falha ao gerar keystore de debug."
    ok "Keystore de debug gerada."
else
    ok "Keystore de debug encontrada."
fi

info "Assinando APK..."
apksigner sign \
    --ks "$KEYSTORE" \
    --ks-pass pass:android \
    --ks-key-alias androiddebugkey \
    --key-pass pass:android \
    --out "$OUTPUT_DIR/${APK_NAME}-signed.apk" \
"$OUTPUT_DIR/${APK_NAME}-aligned.apk"
checar "Falha ao assinar o APK."
ok "APK assinado com sucesso."

# -------------------------------------------------------------
# PASSO 7 — Copiar para Downloads
# Copia o APK final para a pasta Downloads do dispositivo
# para facilitar a instalação.
# -------------------------------------------------------------
info "Passo 7: Copiando APK para Downloads..."
cp "$OUTPUT_DIR/${APK_NAME}-signed.apk" "$DOWNLOADS_DIR/${APK_NAME}.apk"
checar "Falha ao copiar para Downloads. Verifique se termux-setup-storage foi executado."
ok "APK copiado para Downloads."

# =============================================================
# BUILD CONCLUÍDO
# =============================================================
echo "-------------------------------------------"
ok "Build finalizado com sucesso!"
info "APK disponível em: $DOWNLOADS_DIR/${APK_NAME}.apk"
