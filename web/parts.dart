part of gamesystem;

class Dir {
  static const UP = Dir(0, "UP");
  static const DN = Dir(1, "DN");
  static const RT = Dir(2, "RT");
  static const LT = Dir(3, "LT");

  static get values => [UP, DN, LT, RT];

  final int value;
  final String name;

  Dir opposite() {
    switch (value) {
      case 0:
        return DN;
      case 1:
        return UP;
      case 2:
        return LT;
      case 3:
        return RT;
    }
    return RT; // TODO: validate that this is an ok default compared to null
  }

  const Dir(this.value, this.name);
}

class PartResults {
  Dir direction;
  Resource resource;
  double amount;
  PartResults(this.direction, this.resource, this.amount);
}

class Part {

  int compareTo(Part p) {
    return (name + display).compareTo(p.name + p.display);
  }

  Map toJson() {
    Map map = new Map();
    map["index"] = values.indexOf(this);
    return map;
  }

  static Part? load(Map? map) {
    if (map == null) {
      return null;
    }
    return Part.values[map["index"]];
  }

  final String name;
  final String display;
  final List<Dir> inConnections;
  final List<Dir> outConnections;
  final Function process;
  // Process function returns a list of results (direction, resource, amount)
  final List<Resource> accept;
  final double requires;

  const
      Part(this.name, this.display, this.inConnections, this.outConnections, this.process, this.accept, [this.requires
      = 1.0]);

  // Crossed conduits, in V -> out V / in H -> out H
  // FL -> Student (add Cloner achievement)
  // 1000C -> V
  // V -> 1000C

  static get values => [HOPPER_A, HOPPER_B, HOPPER_C, HOPPER_D, HOPPER_E,
      HOPPER_F, CONVERTER_A, CONVERTER_B, CONVERTER_C, DOUBLER_A, DOUBLER_B,
      CONDUIT_A, CONDUIT_B, UNLUNCHER, CORNER_A, CORNER_B, SPLITTER_A, TRANSMUTER_A,
      SINK_A, SHUFFLER, COILER, CORNER_C, UNCOILER, REVERSE_CORNER, PUZZLER,
      CONVERTER_D, RECRUITER, CONDUIT_C, HOPPER_G, CONVERTER_E, CONVERTER_F,
      CONVERTER_G, CONDUIT_D, HOPPER_H, SINK_B];

  static const RECRUITER = Part("Recruiter", "[S->W]", [Dir.UP],
      [Dir.DN], processRecruiter, [Resource.STUDENTS]);

  static const CONVERTER_E = Part("Converter", "[FL->S]", [Dir.LT],
      [Dir.RT], processConverterE, [Resource.FREE_LUNCHES]);

  static const CONVERTER_F = Part("Converter", "[V->1kxC]", [Dir.LT], [Dir.RT], processConverterF, [Resource.VENDING_MACHINES]);

  static const CONVERTER_G = Part("Converter", "[1kxC->V]", [Dir.LT], [Dir.RT], processConverterG, [Resource.COILS]);

  static const HOPPER_G = Part("Hopper", "[+50V->]", [], [Dir.RT], processHopperG, [Resource.VENDING_MACHINES], 50.0);

  static const HOPPER_H = Part("Hopper", "[+S->]", [], [Dir.DN], processHopperH, [Resource.STUDENTS], 1.0);

  static const CONVERTER_D = Part("Converter", "[FL->C]", [Dir.LT],
      [Dir.RT], processConverterD, [Resource.FREE_LUNCHES]);

  static const REVERSE_CORNER = Part("Corner (B)", "[C<-C]", [Dir.UP], [Dir.LT], processReverseCorner, [Resource.COILS]);

  static const PUZZLER = Part("Puzzler", "[*->**/-*]", [Dir.LT],
      [Dir.RT, Dir.DN], processPuzzler, Resource.values);

  static const UNCOILER = Part("Uncoiler", "[-10xC<-C]", [Dir.RT],
      [Dir.LT], processUncoiler, [Resource.COILS]);

  static const CORNER_C = Part("Corner (A)", "[C<-C]", [Dir.RT],
      [Dir.DN], processCornerC, [Resource.COILS]);

  static const COILER = Part("Coiler", "[C<-\$+]", [], [Dir.LT], processCoiler, [Resource.MONEY]);

  static const SINK_A = Part("Sink", "[*->]", [Dir.LT], [],
      processSinkA, Resource.values);

  static const SINK_B = Part("Sink (V)", "[*->]", [Dir.UP], [],
      processSinkB, Resource.values);

  static const TRANSMUTER_A = Part("Transmuter", "[*->\$]", [Dir.LT], [Dir.RT], processTransmuterA, Resource.values);

  static const HOPPER_A = Part("Hopper", "[+\$->]", [], [Dir.RT], processHopperA, [Resource.MONEY]);

  static const HOPPER_B = Part("Hopper", "[+T->]", [], [Dir.RT], processHopperB, [Resource.TRIANGLES]);

  static const HOPPER_C = Part("Hopper", "[+FL->]", [], [Dir.RT], processHopperC, [Resource.FREE_LUNCHES]);

  static const HOPPER_D = Part("Hopper", "[+100B->]", [], [Dir.RT], processHopperD, [Resource.BEADS], 100.0);

  static const HOPPER_E = Part("Hopper", "[+25T->]", [], [Dir.RT], processHopperE, [Resource.TRIANGLES], 25.0);

  static const HOPPER_F = Part("Hopper", "[+\$1000->]", [], [Dir.RT], processHopperF, [Resource.MONEY], 1000.0);

  static const CONVERTER_A = Part("Converter", "[\$->B]", [Dir.LT],
      [Dir.RT], processConverterA, [Resource.MONEY]);

  static const CONVERTER_B = Part("Converter", "[4xB->T]", [Dir.LT],
      [Dir.RT], processConverterB, [Resource.BEADS]);

  static const CONVERTER_C = Part("Converter", "[T->\$100]", [Dir.LT], [Dir.RT], processConverterC, [Resource.TRIANGLES]);

  static const DOUBLER_A = Part("Doubler", "[\$->\$\$]", [Dir.LT],
      [Dir.RT, Dir.DN], processDoublerA, [Resource.MONEY]);

  static const DOUBLER_B = Part("Doubler", "[B->BB]", [Dir.LT],
      [Dir.RT], processDoublerB, [Resource.BEADS]);

  static const UNLUNCHER = Part("Unluncher", "[FL->\$1k]", [Dir.LT],
      [Dir.RT], processUnluncher, [Resource.FREE_LUNCHES]);

  static const CORNER_A = Part("Corner", "[\$->\$]", [Dir.UP], [Dir.RT], processCornerA, [Resource.MONEY]);

  static const CORNER_B = Part("Corner", "[*->*]", [Dir.UP], [Dir.RT], processCornerB, Resource.values);

  static const SPLITTER_A = Part("Splitter", "[\$->B+\$]", [Dir.LT],
      [Dir.RT, Dir.DN], processSplitterA, [Resource.MONEY]);

  static const CONDUIT_A = Part("Conduit(H)", "[*->*]", [Dir.LT],
      [Dir.RT], processConduitA, Resource.values);

  static const CONDUIT_B = Part("Conduit(V)", "[*->*]", [Dir.UP],
      [Dir.DN], processConduitB, Resource.values);

  static const CONDUIT_C = Part("Conduit(B)", "[*<-*]", [Dir.RT],
      [Dir.LT], processConduitC, Resource.values);

  static const CONDUIT_D = Part("Conduit(H/V)", "[*->*]", [Dir.LT,
      Dir.UP], [Dir.RT, Dir.DN], processConduitD, Resource.values);

  static const SHUFFLER = Part("Shuffler", "[*->?]", [Dir.LT], [Dir.RT], processShuffler, Resource.values);

  static Part? findPart(String name) {
    for (Part p in values) {
      if (p.name == name) {
        return p;
      }
    }
    return null;
  }

  String upIcon() {
    if (inConnections.contains(Dir.UP)) {
      return "v";
    }
    if (outConnections.contains(Dir.UP)) {
      return "^";
    }
    return "&nbsp;";
  }

  String downIcon() {
    if (inConnections.contains(Dir.DN)) {
      return "^";
    }
    if (outConnections.contains(Dir.DN)) {
      return "v";
    }
    return "&nbsp;";
  }

  String leftIcon() {
    if (inConnections.contains(Dir.LT)) {
      return "&gt;";
    }
    if (outConnections.contains(Dir.LT)) {
      return "&lt;";
    }
    return "&nbsp;";
  }

  String rightIcon() {
    if (inConnections.contains(Dir.RT)) {
      return "&lt;";
    }
    if (outConnections.contains(Dir.RT)) {
      return "&gt;";
    }
    return "&nbsp;";
  }

  String toHtml() {
    String buffer = "<table border=0 width=100%>";
    // FIRST ROW
    buffer += "<tr><td></td><td><center id='UP_arrow'>" + upIcon() +
        "</center></td><td></td></tr>";
    // SECOND ROW
    buffer += "<tr><td id='LT_arrow'>" + leftIcon() + "</td><td>";
    buffer += "------<br>" + display + "<br>------<br><center>" + name +
        "</center>";
    buffer += "</td><td id='RT_arrow'>" + rightIcon() + "</td></tr>";
    // THIRD ROW
    buffer += "<tr><td></td><td><center id='DN_arrow'>" + downIcon() +
        "</center></td><td></td></tr>";
    buffer += "</table>";

    return buffer;
  }

  String getIconForDirection(Dir direction) {
    switch (direction) {
      case Dir.RT:
        return this.rightIcon();
      case Dir.LT:
        return this.leftIcon();
      case Dir.UP:
        return this.upIcon();
      case Dir.DN:
        return this.downIcon();
    }
    return this.rightIcon(); // was null;
  }
}

List<PartResults> processCoiler(Resource r, double amount, var from) {
  if (from == null && r == Resource.MONEY) {
    PartResults result = new PartResults(Dir.LT, Resource.COILS, amount);
    return [result];
  }
  return [];
}

List<PartResults> processHopperA(Resource r, double amount, var from) {
  return processRegularHopper(from, r, Resource.MONEY, amount);
}

List<PartResults> processRegularHopper(var from, Resource r, Resource requires, double
    amount, [Dir out = Dir.RT]) {
  if (from == null && r == requires) {
    PartResults result = PartResults(out, r, amount);
    return [result];
  }
  return [];
}

List<PartResults> processHopperB(Resource r, double amount, var from) {
  return processRegularHopper(from, r, Resource.TRIANGLES, amount);
}

List<PartResults> processHopperG(Resource r, double amount, var from) {
  return processRegularHopper(from, r, Resource.VENDING_MACHINES, amount);
}

List<PartResults> processHopperH(Resource r, double amount, var from) {
  return processRegularHopper(from, r, Resource.STUDENTS, amount, Dir.DN);
}

List<PartResults> processHopperC(Resource r, double amount, var from) {
  if (from == null && r == Resource.FREE_LUNCHES) {
    PartResults result = PartResults(Dir.RT, r, amount);
    return [result];
  }
  return [];
}

List<PartResults> processHopperD(Resource r, double amount, var from) {
  if (from == null && r == Resource.BEADS) {
    PartResults result = PartResults(Dir.RT, r, amount);
    return [result];
  }
  return [];
}

List<PartResults> processHopperE(Resource r, double amount, var from) {
  if (from == null && r == Resource.TRIANGLES) {
    PartResults result = PartResults(Dir.RT, r, amount);
    return [result];
  }
  return [];
}

List<PartResults> processHopperF(Resource r, double amount, var from) {
  if (from == null && r == Resource.MONEY) {
    PartResults result = PartResults(Dir.RT, r, amount);
    return [result];
  }
  return [];
}

List<PartResults> processConduitA(Resource r, double amount, Dir from) {
  if (from == Dir.LT) {
    PartResults result = new PartResults(Dir.RT, r, amount);
    return [result];
  }
  return [];
}

List<PartResults> processSinkA(Resource r, double amount, Dir from) {
  if (from == Dir.LT) {
    PartResults result = new PartResults(Dir.RT, r, 0.0);
    return [result];
  }
  return [];
}

List<PartResults> processSinkB(Resource r, double amount, Dir from) {
  if (from == Dir.UP) {
    PartResults result = new PartResults(Dir.DN, r, 0.0);
    return [result];
  }
  return [];
}

List<PartResults> processShuffler(Resource r, double amount, Dir? from) {
  if (from == Dir.LT) {
    var rng = new Random();
    int rnd = rng.nextInt(3);
    var valid = [Resource.BEADS, Resource.MONEY, Resource.TRIANGLES];
    PartResults result = PartResults(Dir.RT, valid[rnd], amount);
    return [result];
  }
  return [];
}

List<PartResults> processConduitB(Resource r, double amount, Dir? from) {
  if (from == Dir.UP) {
    PartResults result = PartResults(Dir.DN, r, amount);
    return [result];
  }
  return [];
}

List<PartResults> processConduitD(Resource r, double amount, Dir? from) {
  if (from == Dir.LT) {
    return passTo(r, amount, Dir.RT);
  } else if (from == Dir.UP) {
    return passTo(r, amount, Dir.DN);
  }
  return [];
}

passTo(Resource r, double amount, Dir d) {
  PartResults result = PartResults(d, r, amount);
  return [result];
}

List<PartResults> processConduitC(Resource r, double amount, Dir? from) {
  if (from == Dir.RT) {
    PartResults result = PartResults(Dir.LT, r, amount);
    return [result];
  }
  return [];
}

List<PartResults> processConverterA(Resource r, double amount, Dir? from) {
  if (Part.CONVERTER_A.accept.contains(r) && from == Dir.LT) {
    PartResults result = PartResults(Dir.RT, Resource.BEADS, amount);
    return [result];
  }
  return [];
}

List<PartResults> processConverterB(Resource r, double amount, Dir? from) {
  if (Part.CONVERTER_B.accept.contains(r) && from == Dir.LT && (amount >= 4 ||
      amount <= -4)) {
    PartResults result = new PartResults(Dir.RT, Resource.TRIANGLES, (amount ~/ 4).toDouble());
    return [result];
  }
  return [];
}


List<PartResults> processRecruiter(Resource r, double amount, Dir? from) {
  return processConverter(Part.RECRUITER, r, amount, from,
      Resource.FACTORY_WORKERS, 1, 1);
}


List<PartResults> processConverterE(Resource r, double amount, Dir? from) {
  return processConverter(Part.CONVERTER_E, r, amount, from, Resource.STUDENTS,
      1, 1);
}

List<PartResults> processConverterF(Resource r, double amount, Dir? from) {
  return processConverter(Part.CONVERTER_F, r, amount, from, Resource.COILS, 1,
      1000);
}

List<PartResults> processConverterG(Resource r, double amount, Dir? from) {
  return processConverter(Part.CONVERTER_G, r, amount, from,
      Resource.VENDING_MACHINES, 1000, 1 / 1000);
}

List<PartResults> processConverterD(Resource r, double amount, Dir? from) {
  return processConverter(Part.CONVERTER_D, r, amount, from, Resource.COILS, 1,
      1);
}

processConverter(Part p, Resource inResource, double amount, Dir? from, Resource
    outResource, requiredAmount, multiplier) {
  if (p.accept.contains(inResource) && p.inConnections.contains(from) && (amount
      >= requiredAmount || amount <= -requiredAmount)) {
    PartResults result = PartResults(p.outConnections[0], outResource,
        (amount * multiplier).round().toDouble());
    return [result];
  }
  return [];
}

List<PartResults> processConverterC(Resource r, double amount, Dir? from) {
  if (Part.CONVERTER_C.accept.contains(r) && from == Dir.LT) {
    PartResults result = PartResults(Dir.RT, Resource.MONEY, amount * 100.0);
    return [result];
  }
  return [];
}


List<PartResults> processTransmuterA(Resource r, double amount, Dir? from) {
  if (from == Dir.LT) {
    PartResults result = PartResults(Dir.RT, Resource.MONEY, amount);
    return [result];
  }
  return [];
}

List<PartResults> processCornerA(Resource r, double amount, Dir? from) {
  if (r == Resource.MONEY && from == Dir.UP) {
    PartResults result = PartResults(Dir.RT, r, amount);
    return [result];
  }
  return [];
}

List<PartResults> processCornerB(Resource r, double amount, Dir from) {
  if (from == Dir.UP) {
    PartResults result = new PartResults(Dir.RT, r, amount);
    return [result];
  }
  return [];
}


List<PartResults> processReverseCorner(Resource r, double amount, Dir? from) {
  if (from == Dir.UP && r == Resource.COILS) {
    PartResults result = new PartResults(Dir.LT, r, amount);
    return [result];
  }
  return [];
}

List<PartResults> processCornerC(Resource r, double amount, Dir? from) {
  if (from == Dir.RT && r == Resource.COILS) {
    PartResults result = PartResults(Dir.DN, r, amount);
    return [result];
  }
  return [];
}

List<PartResults> processSplitterA(Resource r, double amount, Dir from) {
  if (r == Resource.MONEY && from == Dir.LT) {
    PartResults result = PartResults(Dir.RT, r, amount);
    PartResults result2 = PartResults(Dir.DN, Resource.BEADS, amount);
    return [result, result2];
  }
  return [];
}

List<PartResults> processUncoiler(Resource r, double amount, Dir from) {
  if (r == Resource.COILS && from == Dir.RT) {
    PartResults r = PartResults(Dir.LT, Resource.COILS, -10 * amount);
    return [r];
  }
  return [];
}

List<PartResults> processUnluncher(Resource r, double amount, Dir from) {
  if (Part.UNLUNCHER.accept.contains(r) &&
      Part.UNLUNCHER.inConnections.contains(from) && from == Dir.LT) {
    PartResults r = PartResults(Dir.RT, Resource.MONEY, amount * 1000);
    return [r];
  }
  return [];
}

List<PartResults> processDoublerA(Resource r, double amount, Dir? from) {
  if (r == Resource.MONEY && from == Dir.LT) {
    PartResults result1 = PartResults(Dir.RT, r, amount);
    PartResults result2 = PartResults(Dir.DN, r, amount);
    return [result1, result2];
  }
  return [];
}

List<PartResults> processPuzzler(Resource r, double amount, Dir? from) {
  if (from == Dir.LT) {
    PartResults result1 = PartResults(Dir.RT, r, 2 * amount);
    PartResults result2 = PartResults(Dir.DN, r, -amount);
    return [result1, result2];
  }
  return [];
}

List<PartResults> processDoublerB(Resource r, double amount, Dir? from) {
  if (r == Resource.BEADS && from == Dir.LT) {
    PartResults result = PartResults(Dir.RT, r, amount * 2);
    return [result];
  }
  return [];
}
