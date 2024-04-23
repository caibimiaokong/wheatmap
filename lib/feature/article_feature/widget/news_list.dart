import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wheatmap/feature/article_feature/bloc/article_bloc.dart';
import 'package:wheatmap/feature/article_feature/model/news_model.dart';

class NewsList extends StatelessWidget {
  const NewsList({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        switch (state.status) {
          case PostStatus.initial:
            return const Center(child: CircularProgressIndicator());
          case PostStatus.success:
            switch (index) {
              case 0:
                return ListBuilder(
                  articles: state.climateNewsList!.articles ?? [],
                  index: 0,
                );
              case 1:
                return ListBuilder(
                  articles: state.agricultureNewsList!.articles ?? [],
                  index: 1,
                );
              case 2:
                return ListBuilder(
                  articles: state.environmentNewsList!.articles ?? [],
                  index: 2,
                );
            }
          case PostStatus.failure:
            return const Center(child: Text('failed to fetch posts'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class ListBuilder extends StatelessWidget {
  const ListBuilder({
    super.key,
    required this.articles,
    required this.index,
  });
  final List<Articles> articles;
  final int index;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PostBloc>().add(UpdatePost(index));
      },
      child: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (ctx, pos) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                InkWell(
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 5),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'lib/asset/photo/news.gif',
                                  image: articles[pos].urlToImage!,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(articles[pos].title!,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Newsreader')),
                              subtitle: Column(
                                children: [
                                  Text(
                                    "${articles[pos].description!.substring(0, 60)}...",
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        articles[pos]
                                            .publishedAt!
                                            .substring(0, 10),
                                        style:
                                            const TextStyle(color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              isThreeLine: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      context.pushNamed(
                        'webview',
                        pathParameters: {'url': articles[pos].url!},
                      );
                    }),
                const Divider(
                  color: Colors.black,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
