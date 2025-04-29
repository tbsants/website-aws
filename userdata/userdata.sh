#!/bin/bash
yum update -y

yum install -y httpd

systemctl start httpd
systemctl enable httpd

cat <<EOF > /var/www/html/index.html

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>TechXperience News</title>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 min-h-screen flex flex-col">

  <!-- Navbar -->
  <nav class="flex items-center justify-between p-6 bg-white shadow-md">
    <div class="text-blue-600 font-bold text-2xl">TechXperience</div>
    <div class="space-x-8">
      <a href="#inicio" class="text-gray-700 hover:text-blue-500 text-lg">Início</a>
      <a href="#noticias" class="text-gray-700 hover:text-blue-500 text-lg">Notícias</a>
      <a href="#videos" class="text-gray-700 hover:text-blue-500 text-lg">Vídeos</a>
      <a href="#contato" class="text-gray-700 hover:text-blue-500 text-lg">Contato</a>
    </div>
  </nav>

  <!-- Hero Banner -->
  <section id="inicio" class="p-6">
    <div class="max-w-7xl mx-auto grid md:grid-cols-2 gap-6">
      <div class="bg-white rounded-xl shadow-md overflow-hidden">
        <img src="https://tse3.mm.bing.net/th?id=OIP.wTA6qG1j7pBOZPMgE0blawHaEv&pid=Api" alt="Principal" class="w-full h-64 object-cover">
        <div class="p-6">
          <span class="text-green-600 font-bold text-sm uppercase">Starlink Mini</span>
          <h2 class="text-2xl font-bold text-gray-800 mt-2">Nova antena da Starlink chega ao Brasil</h2>
          <p class="text-gray-600 mt-4">Roteador embutido e 3kg mais leve para facilitar seu acesso à internet.</p>
        </div>
      </div>

      <div class="flex flex-col space-y-6">
        <div class="bg-white rounded-xl shadow-md overflow-hidden flex-1">
          <img src="https://tse4.mm.bing.net/th?id=OIP.miZhB7sKDcwdQGBN9R2A2wHaEK&pid=Api" alt="Notícia 2" class="w-full h-48 object-cover">
          <div class="p-4">
            <span class="text-purple-600 font-bold text-sm uppercase">Horas de Streaming</span>
            <h3 class="text-xl font-bold text-gray-800 mt-2">Ranking de jogos mais assistidos na Twitch</h3>
          </div>
        </div>
        <div class="bg-white rounded-xl shadow-md overflow-hidden flex-1">
          <img src="https://tse3.mm.bing.net/th?id=OIP.ad-EjtSqFb2yDnTGggd_FQHaFj&pid=Api" alt="Notícia 3" class="w-full h-48 object-cover">
          <div class="p-4">
            <span class="text-pink-600 font-bold text-sm uppercase">História dos Games</span>
            <h3 class="text-xl font-bold text-gray-800 mt-2">Relembrando lançamentos icônicos de 2024</h3>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Footer -->
  <footer class="bg-white mt-16 p-6 text-center text-gray-500 text-sm shadow-inner">
    © 2025 TechXperience. Todos os direitos reservados.
  </footer>

</body>
</html>
EOF