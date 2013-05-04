import javax.swing.SwingWorker;

/**
 *
 * @author fabio
 */
public class StopWorker extends SwingWorker<Integer, Integer> {

    protected Integer doInBackground() throws Exception {
         Start.stop();        
         return 1;  
    }
}
