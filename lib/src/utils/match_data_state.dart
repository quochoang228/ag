import 'package:flutter/material.dart';

import '../../ag.dart';

class MatchDataState<T, E> extends StatefulWidget {
  const MatchDataState({
    super.key,
    required this.state,
    required this.fetched,
    this.notLoaded,
    this.loading,
    this.noData,
    this.failed,
  });

  final DataState<T, E> state;
  final Widget Function(NotLoaded<T>)? notLoaded;
  final Widget Function(Loading<T>)? loading;
  final Widget Function(Fetched<T>) fetched;
  final Widget Function(NoData<T>)? noData;
  final Widget Function(Failed<E>)? failed;

  @override
  State<MatchDataState> createState() => _MatchDataStateState<T, E>();
}

class _MatchDataStateState<T, E> extends State<MatchDataState<T, E>> {
  @override
  Widget build(BuildContext context) {
    return widget.state.match(
      notLoaded: (p0) => widget.notLoaded?.call(p0) ?? const SizedBox(),
      loading: (p0) =>
          widget.loading?.call(p0) ??
          Center(
            child: Text(
              'Đang tải dữ liệu...',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
      noData: (p0) =>
          widget.noData?.call(p0) ??
          Center(
            child: Text(
              'Không có dữ liệu',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
      failed: (p0) =>
          widget.failed?.call(p0) ??
          Center(
            child: Text(
              p0.err is ErrorResponse
                  ? (p0.err as ErrorResponse).message ?? 'Có lỗi xảy ra'
                  : 'Có lỗi xảy ra',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
      // fetched: (p0) => widget.fetched(p0),
      fetched: (state) => widget.fetched(state),
    );
  }
}
