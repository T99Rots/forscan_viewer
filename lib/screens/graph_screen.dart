import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:forscan_viewer/widgets/_widgets.dart';

import '../parser/_parser.dart';
import 'widgets/_widgets.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  late final Future<List<Data>> dataListFuture = _getData();

  Future<List<Data>> _getData() async {
    final String file = await rootBundle.loadString('assets/recording 3.csv');
    return CSVParser.parse(file);
  }

  final Set<Data> selected = <Data>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        surfaceTintColor: Colors.transparent,
        title: const Text('Fiesta ST Data Viewer'),
      ),
      body: FutureBuilder<List<Data>>(
        future: dataListFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Data>> snapshot) {
          if (snapshot.hasData) {
            return _buildLoaded(snapshot.data!);
          }
          if (snapshot.hasError) {
            return _buildError(snapshot.error!);
          }
          return _buildLoading();
        },
      ),
    );
  }

  Row _buildLoaded(List<Data> dataList) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SensorListSidebar(
          data: dataList,
          dataToggled: _handleDataToggle,
          selected: selected,
        ),
        if (selected.isNotEmpty)
          Expanded(
            child: GraphList(
              dataList: dataList.where((Data element) => selected.contains(element)).toList(),
              separatedGraphs: true,
            ),
          ),
        if (selected.isEmpty)
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.info),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'No sensors selected.',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          )
      ],
    );
  }

  void _handleDataToggle(Data data) {
    if (!selected.add(data)) {
      selected.remove(data);
    }
    setState(() {});
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 20,
          ),
          Text(
            'Loading...',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.error,
            color: Colors.red,
          ),
          Text(
            'Error occurred loading data\n$error',
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
