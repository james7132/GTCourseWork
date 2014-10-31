package rip.hw1.planner;

/**
 * Created by ajmalkunnummal on 10/3/14.
 */
public interface Heuristic {
    public double estimate(State start, State goal);
}
