package rip.hw1.planner.sokoban;

import rip.hw1.planner.Heuristic;
import rip.hw1.planner.State;

import javax.swing.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class SokobanState implements State, Comparable {
    private class Item implements Comparable{
        private String name;
        public int x, y;
        private boolean moveable, pushable;
        public Item(String name, int x, int y, boolean moveable, boolean pushable){
            this.name = name;
            this.x = x;
            this.y = y;
            this.moveable = moveable;
            this.pushable = pushable;
        }
        public Item(Item item){
            this(item.name, item.x, item.y, item.moveable, item.pushable);
        }
        public boolean equals(Item item){
            return  item.name.equals(name) &&
                    item.x == x &&
                    item.y == y;
        }
        public int hashcode(){
            return 0;
        }
        public boolean same(Item item){
            return item.name.equals(name);
        }
        public boolean samePos(Item item){
            return x == item.x && y == item.y;
        }

        @Override
        public int compareTo(Object item) {
            return name.compareTo( ((Item)item).name);
        }
    }
    private enum Action {LEFT, RIGHT, UP, DOWN}
    private Item robot;
    private Item[] boxes; // Always kept sorted
    private Item[][] itemGrid;
    private int gridW, gridH;
    boolean[][] walls;
    private Action[] fromStart;
    private double tentativeDistance;
    private boolean named;

    public SokobanState(int gridW, int gridH, boolean[][] walls, String robot, List<String> boxes){
        this.gridW = gridW;
        this.gridH = gridH;
        itemGrid = new Item[gridW][gridH];
        this.walls = walls;
        String p[] = robot.split(" ");
        this.robot = new Item("bot", Integer.parseInt(p[0]), Integer.parseInt(p[1]), true, false);
        this.named = Integer.parseInt(p[2]) == 1;
        itemGrid[this.robot.x][this.robot.y] = this.robot;
        this.boxes = new Item[boxes.size()];
        for(int i = 0; i < this.boxes.length; i++) {
            String box[] = boxes.get(i).split(" ");
            this.boxes[i] = new Item(box[0], Integer.parseInt(box[1]), Integer.parseInt(box[2]), false, true);
            itemGrid[this.boxes[i].x][this.boxes[i].y] = this.boxes[i];
        }
        Arrays.sort(this.boxes);
        fromStart = new Action[0];
    }
    public SokobanState(SokobanState state, Action action){
        gridW = state.gridW;
        gridH = state.gridH;
        itemGrid = new Item[gridW][gridH];
        walls = state.walls;
        robot = new Item(state.robot);
        itemGrid[robot.x][robot.y] = robot;
        boxes = new Item[state.boxes.length];
        for(int i = 0; i < boxes.length; i++) {
            boxes[i] = new Item(state.boxes[i]);
            itemGrid[this.boxes[i].x][this.boxes[i].y] = this.boxes[i];
        }
        fromStart = Arrays.copyOf(state.fromStart, state.fromStart.length + 1);
        fromStart[state.fromStart.length] = action;
        tentativeDistance = 0;
    }
    public boolean equals(Object obj){
        SokobanState state = (SokobanState) obj;
        if(!robot.equals(state.robot))
            return false;
        if(state.boxes.length != boxes.length)
            return false;
        for(int i = 0; i < boxes.length; i++){
            if(!state.boxes[i].equals(boxes[i]))
                return false;
        }
        return true;
    }

    public boolean same(State obj){
        SokobanState state = (SokobanState) obj;
        if(state.boxes.length != boxes.length)
            return false;
        if(named) {
            for (int i = 0; i < boxes.length; i++) {
                if (!state.boxes[i].equals(boxes[i]))
                    return false;
            }
        }
        else {
            for (Item goal: boxes) {
                if(state.itemGrid[goal.x][goal.y] == null || !state.itemGrid[goal.x][goal.y].pushable)
                    return false;
            }
        }
        return true;
    }

    public int hashcode(){
        return 0;
    }
    
    public double getTentativeDistance() {
        return tentativeDistance;
    }

    @Override
    public boolean validate() {
        if(walls[robot.x][robot.y]
                || itemGrid[robot.x][robot.y] != robot)
            return false;
        for(Item box: boxes)
            if(walls[box.x][box.y]
                    || itemGrid[box.x][box.y] != box)
                return false;
        return true;
    }

    @Override
    public boolean canReach(State end) {
        SokobanState goal = (SokobanState) end;
        for (Item box: boxes){
            Item goalb = goal.itemGrid[box.x][box.y];
            if( (goalb == null || named && !box.same(goalb)) && jammed(box) )
                return false;
        }
        return true;
    }

    public void setTentativeDistance(double distance) {
        this.tentativeDistance = distance;
    }

    public int compareTo(Object o) {
        State s = ((State)o);
        return Double.compare(this.getTentativeDistance(), s.getTentativeDistance());
    }

    public List<State> neighbours(){
        List<State> neighbours = new ArrayList<State>();
        if(!walls[robot.x + 1][robot.y]) {
            if(itemGrid[robot.x + 1][robot.y] == null) {
                SokobanState n = new SokobanState(this, Action.RIGHT);
                n.move(n.robot, 1, 0);
                neighbours.add(n);
            }
            else if(!walls[robot.x + 2][robot.y] && itemGrid[robot.x + 2][robot.y] == null) {
                SokobanState n = new SokobanState(this, Action.RIGHT);
                n.move(n.itemGrid[robot.x + 1][robot.y], 1, 0);
                n.move(n.robot, 1, 0);
                neighbours.add(n);
            }
        }
        if(!walls[robot.x - 1][robot.y]) {
            if(itemGrid[robot.x - 1][robot.y] == null) {
                SokobanState n = new SokobanState(this, Action.LEFT);
                n.move(n.robot, -1, 0);
                neighbours.add(n);
            }
            else if(!walls[robot.x - 2][robot.y] && itemGrid[robot.x - 2][robot.y] == null) {
                SokobanState n = new SokobanState(this, Action.LEFT);
                n.move(n.itemGrid[robot.x - 1][robot.y], -1, 0);
                n.move(n.robot, -1, 0);
                neighbours.add(n);
            }
        }
        if(!walls[robot.x][robot.y + 1]) {
            if(itemGrid[robot.x][robot.y + 1] == null) {
                SokobanState n = new SokobanState(this, Action.DOWN);
                n.move(n.robot, 0, 1);
                neighbours.add(n);
            }
            else if(!walls[robot.x][robot.y + 2] && itemGrid[robot.x][robot.y + 2] == null) {
                SokobanState n = new SokobanState(this, Action.DOWN);
                n.move(n.itemGrid[robot.x][robot.y + 1], 0, 1);
                n.move(n.robot, 0, 1);
                neighbours.add(n);
            }
        }
        if(!walls[robot.x][robot.y - 1]) {
            if(itemGrid[robot.x][robot.y - 1] == null) {
                SokobanState n = new SokobanState(this, Action.UP);
                n.move(n.robot, 0, -1);
                neighbours.add(n);
            }
            else if(!walls[robot.x][robot.y - 2] && itemGrid[robot.x][robot.y - 2] == null) {
                SokobanState n = new SokobanState(this, Action.UP);
                n.move(n.itemGrid[robot.x][robot.y - 1], 0, -1);
                n.move(n.robot, 0, -1);
                neighbours.add(n);
            }
        }
        return neighbours;
    }

    private boolean recJammed(Item box, Item par){
        int x = box.x, y = box.y;
        return  ((
                    walls[x + 1][y] ||
                    itemGrid[x + 1][y] != null &&
                    !itemGrid[x + 1][y].moveable &&
                    (par != null && itemGrid[x + 1][y].same(par) || recJammed(itemGrid[x + 1][y], box))
                ) || (
                    walls[x - 1][y] ||
                    itemGrid[x - 1][y] != null &&
                    !itemGrid[x - 1][y].moveable &&
                    (par != null && itemGrid[x - 1][y].same(par) || recJammed(itemGrid[x - 1][y], box))
                )) && ((
                    walls[x][y] ||
                    itemGrid[x][y + 1] != null &&
                    !itemGrid[x][y + 1].moveable &&
                    (par != null && itemGrid[x][y + 1].same(par) || recJammed(itemGrid[x][y + 1], box))
                ) || (
                    walls[x][y - 1] ||
                    itemGrid[x][y - 1] != null &&
                    !itemGrid[x][y - 1].moveable &&
                    (par != null && itemGrid[x][y - 1].same(par) || recJammed(itemGrid[x][y - 1], box))
                ));
    }
    private boolean jammed(Item box) {
        return recJammed(box, null);
    }

    private boolean strictJammed(int x, int y) {
        return  (walls[x + 1][y] || walls[x - 1][y]) &&
                (walls[x][y] || walls[x][y - 1]);
    }

    private void move(Item item, int x, int y){
        item = itemGrid[item.x][item.y];
        itemGrid[item.x][item.y] = null;
        item.x += x;
        item.y += y;
        itemGrid[item.x][item.y] = item;
    }

    public Object[] getActions() {
        return fromStart;
    }

    public static int manhDistance(SokobanState start, SokobanState goal){
        int sum = 0;
        for(int i = 0; i < start.boxes.length; i++){
            sum += Math.abs(start.boxes[i].x - goal.boxes[i].x);
            sum += Math.abs(start.boxes[i].y - goal.boxes[i].y);
        }
        return sum;
    }
}
