# 🗺️ App Minhas Viagens – Mapas e Geolocalização

Aplicativo mobile desenvolvido em Flutter como projeto da disciplina de Desenvolvimento Mobile.

Esta é a **Parte 2 do projeto**, focada em:
- Reverse geocoding (coordenadas → endereço)
- Salvamento de pontos no mapa
- Listagem personalizada das viagens

---

## 📱 Funcionalidades

- Visualização do mapa com localização atual
- Marcação de pontos no mapa
- Chamada à API do Nominatim para obter o endereço
- Edição do nome do ponto antes de salvar
- Lista com os locais salvos
- Exclusão de locais
- SplashScreen de entrada
- Ordenação de locais por distância (opcional)

---

## 🛠️ Tecnologias Utilizadas

- Flutter 3.x
- Dart
- `flutter_map` – Mapa OpenStreetMap
- `latlong2` – Coordenadas
- `geolocator` – Acesso à localização do dispositivo
- `http` – Requisições HTTP para geocoding
- `nominatim.openstreetmap.org` – API gratuita para endereço reverso

---

## 📁 Estrutura do Projeto

lib/
├── geocoding_service.dart # Serviço de reverse geocoding
├── viagem_model.dart # Modelo de dados para a Viagem
├── Mapas.dart # Tela de seleção do ponto no mapa
├── Home.dart # Tela principal com lista de viagens
├── SplashScreen.dart # Tela inicial com logo
└── main.dart # Entrada do app
assets/
└── imagens/logo.png # Logo usada na SplashScreen


---

## 📦 Como rodar o projeto localmente

### 🔹 1. Clone o repositório

```bash
git clone https://github.com/SEU_USUARIO/app_minhas_viagens.git
cd app_minhas_viagens

2. Instale as dependências
flutter pub get

3. Execute o app
flutter run

Para testar no navegador (versão web)
flutter run -d chrome

🌐 Permissões
Adicione esta permissão ao AndroidManifest.xml (já incluso):
<uses-permission android:name="android.permission.INTERNET"/>

🧪 Teste da Aplicação
Clique no botão + na tela principal

Escolha um ponto no mapa e clique no botão ✅

A API retorna os dados do local

Dê um nome personalizado e salve

Veja a viagem listada na tela principal

Você pode excluir clicando no ícone da lixeira vermelha

🎥 Demonstração em Vídeo:

https://drive.google.com/file/d/1uKNcmTjKClNSeUohp2BrIPciVeBGPYwN/view?usp=drive_link

