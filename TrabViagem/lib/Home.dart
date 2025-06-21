import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'geocoding_service.dart';
import 'viagem_model.dart';
import 'Mapas.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Viagem> _listaViagens = [];
  final TextEditingController _filtroController = TextEditingController();
  String _textoBusca = '';

  Future<void> _adicionarLocal() async {
    final selectedLocation = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(builder: (context) => const Mapas()),
    );

    if (selectedLocation != null) {
      await _adicionarViagemDaLocalizacao(selectedLocation);
    }
  }

  Future<void> _adicionarViagemDaLocalizacao(LatLng location) async {
    try {
      final dadosLocal =
          await GeocodingService.getAddressFromCoordinates(location);

      final nomeController = TextEditingController(
        text: dadosLocal['name'] ??
            dadosLocal['address']['amenity'] ??
            'Novo Local',
      );
      final obsController = TextEditingController();

      final confirmado = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmar Local'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                    'Endereço: ${dadosLocal['display_name'] ?? 'Não identificado'}'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome para este local',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: obsController,
                  decoration: const InputDecoration(
                    labelText: 'Observações (opcional)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Salvar'),
            ),
          ],
        ),
      );

      if (confirmado == true) {
        final novaViagem = Viagem.fromJson(
          dadosLocal,
          nomePersonalizado: nomeController.text,
          observacoes: obsController.text,
        );
        setState(() => _listaViagens.add(novaViagem));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar localização: ${e.toString()}')),
      );
    }
  }

  void _excluirViagem(int index) {
    setState(() {
      _listaViagens.removeAt(index);
    });
  }

  Future<void> _abrirNoGoogleMaps(Viagem viagem) async {
    final url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${viagem.coordenadas.latitude},${viagem.coordenadas.longitude}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _compartilharViagem(Viagem viagem) {
    final url =
        'https://www.google.com/maps?q=${viagem.coordenadas.latitude},${viagem.coordenadas.longitude}';
    Share.share('Confira este local: ${viagem.nome}\n$url');
  }

  List<Viagem> get _listaFiltrada {
    if (_textoBusca.isEmpty) return _listaViagens;
    return _listaViagens
        .where((v) => v.nome.toLowerCase().contains(_textoBusca.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas viagens'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _filtroController,
              decoration: InputDecoration(
                hintText: 'Buscar local...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (texto) {
                setState(() {
                  _textoBusca = texto;
                });
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _adicionarLocal,
      ),
      body: _listaFiltrada.isEmpty
          ? const Center(
              child: Text(
                'Nenhum resultado encontrado',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _listaFiltrada.length,
              itemBuilder: (context, index) {
                final viagem = _listaFiltrada[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      viagem.nome,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (viagem.endereco.isNotEmpty) Text(viagem.endereco),
                        if (viagem.observacoes != null &&
                            viagem.observacoes!.isNotEmpty)
                          Text('Obs: ${viagem.observacoes!}'),
                        Text(
                            'Lat: ${viagem.coordenadas.latitude.toStringAsFixed(4)}'),
                        Text(
                            'Lng: ${viagem.coordenadas.longitude.toStringAsFixed(4)}'),
                      ],
                    ),
                    trailing: Wrap(
                      spacing: 6,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.green),
                          onPressed: () => _compartilharViagem(viagem),
                        ),
                        IconButton(
                          icon: const Icon(Icons.map, color: Colors.blue),
                          onPressed: () => _abrirNoGoogleMaps(viagem),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _excluirViagem(_listaViagens.indexOf(viagem)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
