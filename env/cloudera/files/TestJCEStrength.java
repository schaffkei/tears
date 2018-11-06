import javax.crypto.Cipher;

public class TestJCEStrength
{
	public static void main(String [] args) throws Exception
	{
		int allowedKeyLength = Cipher.getMaxAllowedKeyLength("RCS");
		System.out.println("Allowed key length = " + allowedKeyLength);

		boolean ujce = (allowedKeyLength > 256);
		System.out.println("Unlimited Encryption? " + ujce);

		if (ujce)
			System.exit(0);
		else
			System.exit(1);
	}
}
