
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * This class handles the starting of the simulation, it receives the parameters from the GUI,
 * it writes them according to RMASBench specification and it handles the post elaboration of the stats.
 * 
 */
public class Start {
    static Process p = null; 
    static boolean stopped = false;
    static String DEFAULT_CONFIG_FILE_NAME = "params.cfg";
    static String DEFAULT_ALG_TAG = "assignment_class";
    static String DEFAULT_MAP_TAG = "map_directory";
    //static final String DEFAULT_ALG = "Dummy";
    static String DEFAULT_START_TAG = "experiment_start_time";
    //static final String DEFAULT_START_TIME = "20";
    
    //NUMBER OF TEST FOR EACH COMBINATION OF VALUES
    static int number_of_runs = 1;
    static HashMap<String, String[]> params = new HashMap<String, String[]>();
    static HashMap<Integer, String> paramPosition = new HashMap<Integer, String>();
    static ArrayList<String[]> paramValues = new ArrayList<String[]>();
    static String curAlg;
    static String map = "";
    

    /**
     * It starts the simulations.
     * @param filename: the name of the params file
     * @throws IllegalInputException 
     */
    public static void start(String filename) throws IllegalInputException {
        initialize(filename);
        int testNumber = number_of_runs;
        String[] curParams = new String[(paramValues.size()) * 2];
        for (int i = 0; i < params.size(); i++) {
            testNumber *= paramValues.get(i).length;
        }
        //System.out.println("Numero di test da effettuare: "+testNumber);
        for (int i = 0; i < testNumber; i++) {
            /*if (stopped) {
                p = null;
                stopped = false;
                return;
            }*/
            writeParams(i, curParams);
            executeCommand();
        }
    }
    
    /**
     * It reads the file and fills the params structures of the class.
     * @param filename: the name of the params file
     * @throws IllegalInputException 
     */
    private static void initialize(String filename) throws IllegalInputException {
        params.clear();
        paramPosition.clear();
        paramValues.clear();
        int counter = 0;
        try {
            String fileName = "";
                if (!filename.equals("")) {
                    fileName = filename;
                }
                else {
                    fileName = DEFAULT_CONFIG_FILE_NAME;
                }
            
            BufferedReader reader = new BufferedReader(new FileReader(fileName));
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.charAt(0) != '#') {
                    String[] content = line.split(":");
                    String name = content[0];
                    String values = content[1].trim();
                    if (name.equals("number_of_runs")) {
                        number_of_runs = Integer.parseInt(values);
                    }
                    else {
                        String[] valuesArray = values.split(" ");
                        params.put(name, valuesArray);
                        paramPosition.put(counter, name);
                        counter++;
                        paramValues.add(valuesArray);
                    }
                    /*System.out.print(name+" ");
                    System.out.print(values+"\nI valori nell'array sono:\n");
                    for (String value: valuesArray) {
                        System.out.println(value);
                    }*/
                }
            }
            reader.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            System.exit(0);
        } catch (IOException e) {
            e.printStackTrace();
            System.exit(0);
        }
        
        /*if (!params.containsKey(DEFAULT_ALG_TAG)) {
            setDefault(1, counter);
            counter++;
        }
        if (!params.containsKey(DEFAULT_START_TAG)) {
            setDefault(2, counter);
            counter++;
        }*/

    }

    /*private static void setDefault(int status, int counter) {
        if (status == 1) {
            String[] algorithms = new String[1];
            algorithms[0] = DEFAULT_ALG;
            params.put(DEFAULT_ALG_TAG, algorithms);
            paramValues.add(algorithms);
            paramPosition.put(counter, DEFAULT_ALG_TAG);
        } else if (status == 2) {
            String[] start = new String[1];
            start[0] = DEFAULT_START_TIME;
            params.put(DEFAULT_START_TAG, start);
            paramValues.add(start);
            paramPosition.put(counter, DEFAULT_START_TAG);
        }
    }*/

    /**
     * Writes the params in the config file, used by RMASBench
     * @param curTest: the current number of test
     * @param curParams: the params of the current test
     */
    private static void writeParams(int curTest, String[] curParams) {
        int j = paramValues.size() - 1;
        int counter = 0;
        while (j >= 0) {
            int paramChangeValue = 1;
            for (int z = j + 1; z < paramValues.size(); z++) {
                paramChangeValue *= paramValues.get(z).length;
            }
            
            if (curTest % paramChangeValue == 0) {
                curParams[counter] = paramPosition.get(j);
                counter++;
                curParams[counter] = (String) (paramValues.get(j)[(curTest / paramChangeValue) % (paramValues.get(j).length)]);
                counter++;
            }
            j--;
        }

        String alg = "";

        for (int i = 0; i < curParams.length - 1; i++) {
            if (curParams[i].equals(DEFAULT_ALG_TAG)) {
                alg = curParams[i + 1];
                break;
            }
        }
        for (int i = 0; i < curParams.length - 1; i++) {
            if (curParams[i].equals(DEFAULT_MAP_TAG)) {
                map = curParams[i + 1];
                break;
            }
        }

        try {
            BufferedWriter out;
            if (!alg.equals("")) {
                curAlg = alg;
                out = new BufferedWriter(new FileWriter(new File("config/" + curAlg + ".cfg")));
            } else {
                out = null;
            }
            out.write("!include common.cfg\n");
            for (int i = 0; i < (curParams.length) - 1; i++) {

                if (i % 2 == 0) {
                    //System.out.println(curParams[i]+": "+curParams[i+1]);
                    out.write(curParams[i] + ": " + curParams[i + 1] + "\n");
                    out.flush();
                }
            }
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
            System.exit(0);
        }
    }
    
    /**
     * It executes a test.
     */
    public static void executeCommand() {
        try {
            /*if (stopped) {
                return;
            }*/
            File temp = new File("config_single.sh");
            BufferedWriter bw = new BufferedWriter(new FileWriter(temp));
            bw.write("alg=" + "\"" + curAlg + "\"\n");
            bw.write("map=" + "\"" + map + "\"");
            bw.flush();
            bw.close();

            ProcessBuilder pb = new ProcessBuilder("/bin/bash", "run_single_alg.sh");
            try {
                pb.redirectErrorStream(true);
                p = pb.start();
                BufferedReader buf = new BufferedReader(new InputStreamReader(p.getInputStream()));

                String line = "";
                while ((line = buf.readLine()) != null) {
                    System.out.println(line);
                }
                p.waitFor();
               
            } catch (Exception e) {
                e.printStackTrace();
            }
            temp.delete();
            
        } catch (IOException e) {
        }
        postElaboration();

    }
    
    public static void stop() {
        stopped = true;
        if (p != null) {
            try {
                ProcessBuilder pb2 = new ProcessBuilder("killall", "xterm");
                Process p2 = pb2.start();
                p2.waitFor();
                p.destroy();
                postElaboration();
                ProcessBuilder pb3 = new ProcessBuilder("./results/plot.sh");
                pb3.redirectErrorStream(true);
                Process p3 = pb3.start();
                BufferedReader buf = new BufferedReader(new InputStreamReader(p3.getInputStream()));
                String line = "";
                while ((line = buf.readLine()) != null) {
                    System.out.println(line);
                }               
                p3.waitFor();
                //Process pstop = new ProcessBuilder("killall", "java").start();
                //pstop.waitFor();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    public static void postElaboration() {
        //SimpleDateFormat date = new SimpleDateFormat("dd_MM_yy@hh:mm:ss");
        ProcessBuilder pbpost = new ProcessBuilder("./post_elaboration.sh", /*date.format(new Date())*/ "test", curAlg);
        try {
                pbpost.redirectErrorStream(true);
                Process ppost = pbpost.start();
                BufferedReader buf = new BufferedReader(new InputStreamReader(ppost.getInputStream()));
                String line = "";
                while ((line = buf.readLine()) != null) {
                    System.out.println(line);
                }               
                ppost.waitFor();
            } catch (Exception e) {
                e.printStackTrace();
            }
    }
}
