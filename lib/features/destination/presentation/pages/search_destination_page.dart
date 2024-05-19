import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:travel/api/urls.dart';
import 'package:travel/common/app_route.dart';
import 'package:travel/features/destination/domain/entities/destination_entity.dart';
import 'package:travel/features/destination/presentation/bloc/search_destination/search_destination_bloc.dart';
import 'package:travel/features/destination/presentation/widget/circle_loading.dart';
import 'package:travel/features/destination/presentation/widget/parallax_vertical_delegate.dart';
import 'package:travel/features/destination/presentation/widget/text_failure.dart';

class SearchDestinationPage extends StatefulWidget {
  final String searchText;
  const SearchDestinationPage({super.key, required this.searchText});

  @override
  State<SearchDestinationPage> createState() => _SearchDestinationPageState();
}

class _SearchDestinationPageState extends State<SearchDestinationPage> {
  final editSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.searchText == '') {
      context.read<SearchDestinationBloc>().add(OnResetSearchDestination());
    } else {
      search(widget.searchText);
      editSearch.text = widget.searchText;
    }
  }

  search(String text) {
    if (text == '') return;
    context.read<SearchDestinationBloc>().add(OnSearchDestination(text));
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.only(
          top: 60,
          bottom: 80,
        ),
        child: buildSearch(),
      ),
      bottomSheet: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height - 140,
          child: BlocBuilder<SearchDestinationBloc, SearchDestinationState>(
            builder: (context, state) {
              if (state is SearchDestinationLoading) {
                return const CircleLoading();
              }
              if (state is SearchDestinationFailure) {
                return TextFailure(message: state.message);
              }
              if (state is SearchDestinationLoaded) {
                List<DestinationEntity> list = state.data;
                return ListView.builder(
                  itemCount: list.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    DestinationEntity destinationEntity = list[index];
                    return Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                        bottom: index == list.length - 1 ? 0 : 10,
                      ),
                      child: itemSearch(destinationEntity),
                    );
                  },
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget itemSearch(DestinationEntity destination) {
    final imageKey = GlobalKey();
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoute.detailDestination,
          arguments: destination,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: AspectRatio(
          aspectRatio: 2,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Builder(builder: (context) {
                return Flow(
                  delegate: ParallaxVertDelegate(
                    scrollable: Scrollable.of(context),
                    listItemContext: context,
                    backgroundImageKey: imageKey,
                  ),
                  children: [
                    ExtendedImage.network(
                      URLs.image(destination.cover),
                      key: imageKey,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      handleLoadingProgress: true,
                      loadStateChanged: (state) {
                        if (state.extendedImageLoadState == LoadState.failed) {
                          return Material(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.black,
                            ),
                          );
                        }
                        if (state.extendedImageLoadState == LoadState.loading) {
                          return Material(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey[300],
                            child: const CircleLoading(),
                          );
                        }
                        return null;
                      },
                    ),
                  ],
                );
              }),
              Align(
                alignment: Alignment.bottomCenter,
                child: AspectRatio(
                  aspectRatio: 4,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        Colors.black87,
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    )),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                destination.name,
                                style: const TextStyle(
                                  height: 1,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                destination.location,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RatingBar.builder(
                          initialRating: destination.rate,
                          allowHalfRating: true,
                          unratedColor: Colors.grey,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (value) {},
                          itemSize: 15,
                          ignoreGestures: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearch() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: <Widget>[
          IconButton.filledTonal(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              controller: editSearch,
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search Destination Here...',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: EdgeInsets.all(0),
              ),
              cursorColor: Colors.white,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton.filledTonal(
            onPressed: () {
              search(editSearch.text);
            },
            icon: const Icon(
              Icons.search,
            ),
          )
        ],
      ),
    );
  }
}
