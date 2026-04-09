package control;
//import org.apache.commons.logging.Log;
//import org.apache.commons.logging.LogFactory;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class Ubcrypt {
	static final Ubcrypt ubcrypt = new Ubcrypt();
	static final BCryptPasswordEncoder bcrypt = new BCryptPasswordEncoder();
	private Ubcrypt() {}
	//private static final Log log = LogFactory.getLog(Ubcrypt.class);
	
	static Ubcrypt getInstance() {
		return ubcrypt;
	}
	String encodePw(String pw) {
		String hashedPassword = bcrypt.encode(pw);
		//log.debug("Encoded password: " + hashedPassword);
		return hashedPassword;
	}
	boolean matchesPw(String pw, String encoded) {
		boolean matches = bcrypt.matches(pw, encoded);
		//log.debug("Password match result: " + matches);
		System.out.println("パスワードの比較結果: " + matches);
		return matches;
	}
	
    
}