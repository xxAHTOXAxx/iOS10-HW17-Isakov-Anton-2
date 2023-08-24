import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonGeneratePassword: UIButton!
    @IBOutlet weak var buttonPasswordCracking: UIButton!
    @IBOutlet weak var load: UIActivityIndicatorView!
    @IBOutlet weak var labelFieldForPassword: UILabel!
    @IBOutlet weak var textFieldForPassword: UITextField!
    private var password = "Пароль еще не взломан" {
        didSet {
            textFieldForPassword.text = password
        }
    }
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }
    
    @IBAction func onBut(_ sender: Any) {
        isBlack.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldForPassword.isSecureTextEntry = true
        self.labelFieldForPassword.text = password
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func gereratePassword(_ sender: Any) {
        textFieldForPassword.isSecureTextEntry = true
        password = "9r1"
        labelFieldForPassword.text = "Пароль еще не взломан"
    }
    
    @IBAction func crackPassword(_ sender: Any) {
        let queue = DispatchQueue (label: "queue", qos: .background, attributes: .concurrent)
        buttonGeneratePassword.isEnabled = false
        buttonPasswordCracking.isEnabled = false
        textFieldForPassword.isSecureTextEntry = true
        load.startAnimating()
        queue.async {
            self.bruteForce(passwordToUnlock: String(self.password))
            
            DispatchQueue.main.async {
                self.labelFieldForPassword.text = "Пароль взломан"
                self.load.stopAnimating()
                self.textFieldForPassword.isSecureTextEntry = false
                self.buttonGeneratePassword.isEnabled = true
                self.buttonPasswordCracking.isEnabled = true
            }
        }
    }
    
    
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }
        
        var password: String = ""
        
        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
            //             Your stuff here
            print(password)
            // Your stuff here
        }
        
        print(password)
    }
}

extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }
    
    
    
    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}

func indexOf(character: Character, _ array: [String]) -> Int {
    return array.firstIndex(of: String(character))!
}

func characterAt(index: Int, _ array: [String]) -> Character {
    return index < array.count ? Character(array[index])
    : Character("")
}

func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
    var str: String = string
    
    if str.count <= 0 {
        str.append(characterAt(index: 0, array))
    }
    else {
        str.replace(at: str.count - 1,
                    with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))
        
        if indexOf(character: str.last!, array) == 0 {
            str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
        }
    }
    
    return str
}

