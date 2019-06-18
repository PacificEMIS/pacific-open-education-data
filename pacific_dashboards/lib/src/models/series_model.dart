abstract class Series {}

class BarSeries extends Series {
  final int clicks;
  final String year;
  final String color;

  BarSeries({
    this.year,
    this.clicks,
    this.color,
  });

  factory BarSeries.fromJson(Map<String, dynamic> parsedJson) {
    return BarSeries(
      year: parsedJson['year'],
      clicks: parsedJson['clicks'],
      color: parsedJson['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'clicks': clicks,
      'color': color,
    };
  }
}

class CircleSeries extends Series {
  final int year;
  final int sales;
  final String color;

  CircleSeries({this.year, this.sales, this.color});

  factory CircleSeries.fromJson(Map<String, dynamic> parsedJson) {
    return CircleSeries(
      year: parsedJson['year'],
      sales: parsedJson['sales'],
      color: parsedJson['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'years': year,
      'sales': sales,
      'color': color,
    };
  }
}

class UnknownSeries extends Series {
  final String data;

  UnknownSeries({
    this.data,
  });

  factory UnknownSeries.fromJson(Map<String, dynamic> parsedJson) {
    return UnknownSeries(
      data: parsedJson.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
    };
  }
}
