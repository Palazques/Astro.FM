import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AstroFmApp());
}

class AstroFmApp extends StatelessWidget {
  const AstroFmApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Astro.FM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Podcast {
  final String id;
  final String title;
  final String description;
  Podcast({required this.id, required this.title, required this.description});
}

final samplePodcasts = <Podcast>[
  Podcast(id: '1', title: 'Cosmic Chats', description: 'Short explorations of the night sky.'),
  Podcast(id: '2', title: 'Orbiting Ideas', description: 'Interviews with astronomers and makers.'),
  Podcast(id: '3', title: 'Starlight Stories', description: 'Audio essays about space and science.'),
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? playingId;

  void _openDetails(Podcast p) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => DetailsPage(podcast: p)));
  }

  void _togglePlay(String id) {
    setState(() {
      if (playingId == id) {
        playingId = null;
      } else {
        playingId = id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Astro.FM'),
        actions: [
          IconButton(
            tooltip: 'About',
            icon: const Icon(Icons.info_outline),
            onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'Astro.FM',
              applicationVersion: '0.1.0',
              children: const [Text('Starter app for cross-platform Flutter')],
            ),
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;
        return Padding(
          padding: const EdgeInsets.all(12),
          child: isWide
              ? Row(
                  children: [
                    Flexible(flex: 2, child: _buildList()),
                    const SizedBox(width: 12),
                    Flexible(
                      flex: 3,
                      child: playingId == null
                          ? const Center(child: Text('Select a podcast', style: TextStyle(fontSize: 18)))
                          : DetailsPanel(podcast: samplePodcasts.firstWhere((p) => p.id == playingId)),
                    )
                  ],
                )
              : _buildList(),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Explore Astro.FM features')));
        },
        icon: const Icon(Icons.explore),
        label: const Text('Explore'),
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      itemCount: samplePodcasts.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final p = samplePodcasts[index];
        final isPlaying = p.id == playingId;
        return ListTile(
          leading: CircleAvatar(child: Text(p.title[0])),
          title: Text(p.title),
          subtitle: Text(p.description),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
              icon: Icon(isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline),
              onPressed: () => _togglePlay(p.id),
              tooltip: isPlaying ? 'Pause' : 'Play',
            ),
            IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () => _openDetails(p),
              tooltip: 'Open details',
            ),
          ]),
          onTap: () => _openDetails(p),
        );
      },
    );
  }
}

class DetailsPage extends StatelessWidget {
  final Podcast podcast;
  const DetailsPage({Key? key, required this.podcast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(podcast.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(podcast.description, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Play pressed (stub)')));
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play (stub)'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsPanel extends StatelessWidget {
  final Podcast podcast;
  const DetailsPanel({Key? key, required this.podcast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(podcast.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(podcast.description),
          const Spacer(),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.info_outline),
                label: const Text('More'),
              )
            ],
          )
        ]),
      ),
    );
  }
}
