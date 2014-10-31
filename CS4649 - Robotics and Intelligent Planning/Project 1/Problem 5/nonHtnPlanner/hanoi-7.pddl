(define (problem hanoi-7)
  (:domain hanoi-domain)
  (:objects p1 p2 p3 d1 d2 d3 d4 d5 d6 d7)
  (:init (smaller d1 p1) (smaller d2 p1) (smaller d3 p1) (smaller d4 p1) (smaller d5 p1) (smaller d6 p1) (smaller d7 p1)
        (smaller d1 p2) (smaller d2 p2) (smaller d3 p2) (smaller d4 p2) (smaller d5 p2) (smaller d6 p2) (smaller d7 p2)
        (smaller d1 p3) (smaller d2 p3) (smaller d3 p3) (smaller d4 p3) (smaller d5 p3) (smaller d6 p3) (smaller d7 p3)
        (smaller d1 d2) (smaller d1 d3) (smaller d1 d4) (smaller d1 d5) (smaller d1 d6) (smaller d1 d7) 
                        (smaller d2 d3) (smaller d2 d4) (smaller d2 d5) (smaller d2 d6) (smaller d2 d7) 
                                        (smaller d3 d4) (smaller d3 d5) (smaller d3 d6) (smaller d3 d7) 
                                                        (smaller d4 d5) (smaller d4 d6) (smaller d4 d7) 
                                                                        (smaller d5 d6) (smaller d5 d7) 
                                                                                        (smaller d6 d7) 
                                                                                                        


        (clear p1) (clear p2) (clear d1)
        (disk d1) (disk d2) (disk d3) (disk d4) (disk d5) (disk d6) (disk d7)
        (on d1 d2) (on d2 d3) (on d3 d4) (on d4 d5) (on d5 d6) (on d6 d7) (on d7 p3)
    )
  (:goal (and (on d1 d2) (on d2 d3) (on d3 d4) (on d4 d5) (on d5 d6) (on d6 d7) (on d7 p1) ))
  )

