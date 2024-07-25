class UnbordingContent {
  String image;
  String title;
  String description;

  UnbordingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Unlock Creativity at Your Fingertips',
      image: 'images/sample_3d.png',
      description:
          "Find the perfect graphic designer to bring your vision to life."),
  UnbordingContent(
      title: 'Your Talent, Your Terms',
      image: 'images/sample_3d.png',
      description:
          "Discover opportunities that match your skills, bid on jobs, complete projects, and get paid securely. Showcase your creativity and grow your freelance career."),
  UnbordingContent(
      title: 'Connecting Passion with Purpose',
      image: 'images/sample_3d.png',
      description:
          "Join our thriving community of clients and freelancers. Collaborate on exciting projects, achieve your goals, and experience the synergy of creative minds working together."),
  ];
