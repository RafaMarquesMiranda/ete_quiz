class User {
  String email;
  String senha;
  String nome;
  bool isprofessor;
  int pontos;
  String uid;
  User({this.uid});
  String serie;

  Map<String,dynamic>toMap(){
    Map<String,dynamic> map   ={
     "nome":this.nome,
      "isprofessor": this.isprofessor,
      "pontos":this.pontos,
      "serie":this.serie,
      "email":this.email
    };
    return map;
  }

}
