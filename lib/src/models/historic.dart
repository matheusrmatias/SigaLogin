class Historic{
  String acronym;
  String name;
  String period;
  double avarage;
  double frequency;
  int absence;
  String observation;

  Historic(
      {
        required this.acronym,
        required this.name,
        required this.period,
        required this.avarage,
        required this.frequency,
        required this.absence,
        required this.observation
      }
  );

  Historic.empty({
    this.acronym = '',
    this.name = '',
    this.period = '',
    this.avarage = 0,
    this.frequency = 0,
    this.absence = 0,
    this.observation = ''
  });
}