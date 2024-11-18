class ENV {
  String? apikey;
  String? region;
  ENV(this.apikey, this.region);
}

ENV? env = ENV(const String.fromEnvironment("AMITY_API_KEY"), "eu");
