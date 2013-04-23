
public class IllegalInputException extends Exception {

    public IllegalInputException(int error) {
        if (error == 0) {
            System.out.println("No input parameters.");
            System.out.println("Type \"./Start -h\" to  print usage.");
            System.exit(0);
        }
        if (error == 1) {
            System.out.println("No valid input parameters.");
            System.out.println("Type \"./Start -h\" to  print usage.");
            System.exit(0);
        }
    }
}
