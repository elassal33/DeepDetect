class SegnatureModel {
  final double similarityPercentage;
  final double SignatureToVerify;
  final bool signatureWasNotForged;

  SegnatureModel({required this.similarityPercentage, required this.SignatureToVerify, required this.signatureWasNotForged});


  factory SegnatureModel.fromJson(jsonData){
    return SegnatureModel(
      similarityPercentage: jsonData['similarityPercentage'], 
      SignatureToVerify: jsonData['SignatureToVerify'], 
      signatureWasNotForged: jsonData['signatureWasNotForged'],
      );
  }

  
}