package rip.hw1.planner;
import com.sun.webpane.webkit.Timer;

import javax.xml.datatype.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.PriorityQueue;
import java.util.LinkedList;
/**
 * Created by ajmalkunnummal on 10/3/14.
 */
public class AStar implements Planner {
    private int numExplored;
    private long timeTaken;
    private Object[] path;
    private String string;
    private boolean foundGoal;

    public AStar(State start, State end, Heuristic heuristic){
        numExplored = 0;
        foundGoal = false;
        timeTaken = System.nanoTime();
        run(start, end, heuristic);
        timeTaken = System.nanoTime() - timeTaken;
        generateString();
    }

    private boolean run(State start, State end, Heuristic heuristic) {
        PriorityQueue<State> pq = new PriorityQueue<State>();
        List<State> visited = new ArrayList<State>();
        pq.add(start);
        while(!pq.isEmpty()) {
            State current = pq.poll();
            if(current.same(end)) {
                path = current.getActions();
                numExplored = pq.size() + visited.size();
                foundGoal = true;
                return true;
            }
            visited.add(current);
            for(State s : current.neighbours()) {
                if(!visited.contains(s) && s.canReach(end)) {
                    s.setTentativeDistance(s.getActions().length + heuristic.estimate(s,end));
                    pq.add(s);
                }
            }
        }
        numExplored = pq.size() + visited.size();
        return false;
    }

    public String toString(){
        return string;
    }

    private void generateString(){
        StringBuilder out = new StringBuilder();
        if (foundGoal) {
            out.append("Found goal in " + path.length + " steps\nPath: ");
            for (Object action : path)
                out.append(action + " ");
        }
        else {
            out.append("Did not find goal :(");
        }
        out.append("\nTime taken: " + timeTaken / 60000000000l + "m " + (timeTaken % 60000000000l)  / 1000000000.
                + "s\nNo of states explored: " + numExplored);
        string = out.toString();
    }

    @Override
    public Object getPath() {
        return path;
    }

    @Override
    public int numExplored() {
        return numExplored;
    }

    @Override
    public int numSteps() {
        return path.length;
    }

    @Override
    public long timeTaken() {
        return timeTaken;
    }

    @Override
    public boolean foundGoal() {
        return foundGoal;
    }
}
