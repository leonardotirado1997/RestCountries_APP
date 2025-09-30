import 'dart:convert'; // Biblioteca para trabalhar com JSON (converter texto JSON em objetos Dart)
import 'package:http/http.dart'
    as http; // Biblioteca HTTP para fazer requisições na internet

// Classe que representa os dados de um país
class Country {
  final String name; // Nome do país
  final String capital; // Capital do país
  final String region; // Região (ex: Americas, Europe, Asia)
  final int population; // População total

  // Construtor da classe
  Country({
    required this.name,
    required this.capital,
    required this.region,
    required this.population,
  });

  // Método "factory" para criar um objeto Country a partir de JSON
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']['common'], // Nome comum do país
      capital: (json['capital'] != null && json['capital'].isNotEmpty)
          ? json['capital'][0] // Pega a primeira capital (alguns países têm mais de uma)
          : 'Sem capital', // Caso o país não tenha capital definida
      region: json['region'], // Região geográfica
      population: json['population'], // População
    );
  }

  // Sobrescreve o método toString() para exibir o país de forma organizada
  @override
  String toString() {
    return '''
==== País: $name ====
Capital: $capital
Região: $region
População: $population
''';
  }
}

// Função que faz a requisição para a API RestCountries e retorna uma lista de países
Future<List<Country>> fetchCountries() async {
  // URL da API, pedindo apenas os campos necessários (name, capital, region, population)
  const url =
      'https://restcountries.com/v3.1/all?fields=name,capital,region,population';

  // Fazendo a requisição GET
  final response = await http.get(Uri.parse(url));

  // Se a requisição for bem-sucedida (status 200 = OK)
  if (response.statusCode == 200) {
    // Converte o corpo da resposta (JSON em texto) para uma lista dinâmica
    List<dynamic> data = jsonDecode(response.body);

    // Transforma cada item JSON em um objeto Country e retorna como lista
    return data.map((json) => Country.fromJson(json)).toList();
  } else {
    // Caso a requisição falhe, lança uma exceção com o código de erro
    throw Exception('Erro ao buscar países: ${response.statusCode}');
  }
}

// Função principal do programa
void main() async {
  print('Buscando países...\n');

  try {
    // Chama a função que busca os países
    List<Country> countries = await fetchCountries();

    // Exibe apenas os 5 primeiros países para não poluir o console
    for (var i = 0; i < 5; i++) {
      print(countries[i]); // Como sobrescrevemos toString(), imprime formatado
    }
  } catch (e) {
    // Caso ocorra algum erro, exibe no console
    print('Erro: $e');
  }
}
