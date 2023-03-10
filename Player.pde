// Players: name, gender (random adjectives), cringe (chance of total beefitude), dumbassery (choice of stroke type), yeetness (strength), trigonometry (accuracy),
//          bisexuality (curve skill), asexuality (hole-in-one chance), scrappiness (skill in rough areas), charisma (get it in the hole ;3), autism (magic)

class Player {
  String id, firstName, lastName, gender;
  float cringe, dumbassery, yeetness, trigonometry, bisexuality, asexuality, scrappiness, charisma, autism;
  int networth;
  ArrayList<Effect> mods = new ArrayList<Effect>();

  // Full random player gen
  Player(String _id) {
    id = _id;
    firstName = generateRandomFromList("data/firstnames.txt");
    lastName = generateRandomFromList("data/lastnames.txt");
    gender = generateRandomFromList("data/genders.txt");
    cringe = generateRandomStat();
    dumbassery = generateRandomStat();
    yeetness = generateRandomStat();
    trigonometry = generateRandomStat();
    bisexuality = generateRandomStat();
    asexuality = generateRandomStat();
    scrappiness = generateRandomStat();
    charisma = generateRandomStat();
    autism = generateRandomStat();
    networth = generateNetWorth();
  }

  // Custom player gen
  Player(JSONObject json) {
    id = json.getString("id");
    firstName = json.getString("firstName");
    lastName = json.getString("lastName");
    gender = json.getString("gender");
    cringe = json.getFloat("cringe");
    dumbassery = json.getFloat("dumbassery");
    yeetness = json.getFloat("yeetness");
    trigonometry = json.getFloat("trigonometry");
    bisexuality = json.getFloat("bisexuality");
    asexuality = json.getFloat("asexuality");
    scrappiness = json.getFloat("scrappiness");
    charisma = json.getFloat("charisma");
    autism = json.getFloat("autism");
    networth = json.getInt("networth");
  }

  JSONObject toJSON() {
    JSONObject json = new JSONObject();

    json.setString("id", id);
    json.setString("firstName", firstName);
    json.setString("lastName", lastName);
    json.setString("gender", gender);
    json.setFloat("cringe", cringe);
    json.setFloat("dumbassery", dumbassery);
    json.setFloat("yeetness", yeetness);
    json.setFloat("trigonometry", trigonometry);
    json.setFloat("bisexuality", bisexuality);
    json.setFloat("asexuality", asexuality);
    json.setFloat("scrappiness", scrappiness);
    json.setFloat("charisma", charisma);
    json.setFloat("autism", autism);
    json.setInt("networth", networth);

    return json;
  }

  // Generates a random float via normal distribution w mean 6 and s.d. 2
  float generateRandomStat() {
    return 6 + randomGaussian() * 2;
  }
    
  // Generates a random net worth
  int generateNetWorth() {
    float r = random(0,100);
    if (r < 70) {
      return int(random(-20000,60000));
    }
    else if (r < 99) {
      return int(random(40000,100000));
    }
    else {
      return int(random(100000,200000));
    }
  }
}
