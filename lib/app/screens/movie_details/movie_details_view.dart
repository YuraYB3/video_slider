import 'package:flutter/material.dart';
import 'package:megogo_prototype/app/screens/movie_details/movie_details_view_model.dart';
import 'package:megogo_prototype/app/theme/colors_palette.dart';

import '../../../domain/movie/imovie.dart';
import 'widgets/bottom_row_widget.dart';
import 'widgets/vertical_list_widget.dart';

class MovieDetailScreen extends StatefulWidget {
  final MovieDetailsViewModel model;
  const MovieDetailScreen({super.key, required this.model});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void dispose() {
    super.dispose();
    widget.model.disposeControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: mainColor,
        foregroundColor: secondaryColor,
      ),
      backgroundColor: mainColor,
      body: StreamBuilder<List<IMovie>>(
        stream: widget.model.movieStreamList,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "ERROR${snapshot.error}",
                style: TextStyle(color: secondaryColor, fontSize: 24),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: secondaryColor),
            );
          }
          final List<IMovie> movieData = snapshot.data!;
          return Column(
            children: [
              VerticalListWidget(
                movieData: movieData,
                onHorizontalScroll: widget.model.onHorizontalScroll,
                onVerticalScroll: widget.model.onVerticalScroll,
                verticalPageController: widget.model.verticalPageController,
              ),
              BottomRowWidget(
                listLength:
                    movieData[widget.model.currentVerticalIndex].trailer.length,
                currentHorizontalIndex: widget.model.currentHorizontalIndex,
              ),
              const SizedBox(
                height: 40,
              )
            ],
          );
        },
      ),
    );
  }
}

