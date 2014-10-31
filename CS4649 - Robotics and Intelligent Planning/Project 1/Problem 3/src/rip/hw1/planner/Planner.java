package rip.hw1.planner;

/**
 * Created by ajmalkunnummal on 10/3/14.
 */
public interface Planner {
    public Object getPath();
    public String toString();
    public int numExplored();
    public int numSteps();
    public long timeTaken();
    public boolean foundGoal();

}
