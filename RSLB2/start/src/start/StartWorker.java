/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import javax.swing.SwingWorker;

/**
 *
 * @author fabio
 */
public class StartWorker extends SwingWorker<Integer, Integer> {

    protected Integer doInBackground() throws Exception {
        try {
         Start.start("");
         } catch (IllegalInputException e) {
             
         }
      return 1;  
    }
}
