-- pong-8 / junkdeck

-- constants
p_speed = 5
p_accel = 1
p_deccel = 1
deadzone = 1

function _init()
  pw=4      -- paddle width
  ph=16     -- paddle height
  bd=2      -- ball diameter

  -- spawning coords for ball
  bspw={x=63, y=20}

  p1={
    id=0,
    x=0,
    y=0,
    sc=0,
    _v={x=0, y=0}
  }
  p2={
    id=1,
    x=123,
    y=0,
    sc=0,
    _v={x=0, y=0}
  }

  b={
    x=bspw.x,
    y=bspw.y,
    _v={x=1, y=1}
  }
end

function stopplayer(p, y)
  p._v.y = 0
  p.y = y
end

function playerdeccel(p)

  if(p._v.y < deadzone and p._v.y > -deadzone) then
    p._v.y = 0
  else
    p._v.y -= p_deccel*sgn(p._v.y)
  end
end

function playermove(p)
  -- move player by applying
  -- acceleration to velocity

  if(btn(⬆️, p.id)) then
    p._v.y -= p_accel
  elseif(btn(⬇️, p.id)) then
    p._v.y += p_accel
  else
    playerdeccel(p)
  end

  -- limit player speed
  if(abs(p._v.y) > p_speed) then
    p._v.y = sgn(p._v.y) * p_speed
  end

  -- player movement
  p.y += p._v.y

end

function playerbounds(p)
  if(p.y > 127-ph) stopplayer(p, 127-ph)
  if(p.y < 0) stopplayer(p, 0)
end

function collide(a, b)

  local x1, x2 = a.x, a.x+pw
  local y1, y2 = a.y, a.y+ph

  local bx1, bx2 = b.x, b.x+bd
  local by1, by2 = b.y, b.y+bd

  if(
    (bx1 > x1 and bx1 < x2
    and by1 > y1 and by1 < y2)
    or
    (bx2 > x1 and bx2 < x2 
    and by2 > y1 and by2 < y2)
    ) then
    return true
  else return false	end

end

function drawscore(p, x)
  numtable = {
    [0] = 10,
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
    [5] = 5,
    [6] = 6,
    [7] = 7,
    [8] = 8,
    [9] = 9,
  }

  score = tostr(p.sc)

  for n=1,#score do
    c=sub(score, n, n)

    spr(numtable[tonum(c)], 
    x-(#score*4)+(n*8), 0)
  end

end



function _update()
  -- player 1 controls
  playermove(p1)

  -- player 2 controls
  playermove(p2)

  -- player bounds
  playerbounds(p1)
  playerbounds(p2)



  -- ball boundaries
  if(b.x > 128-bd or b.x < 0) b._v.x *= -1
  if(b.y > 128-bd or b.y < 0) b._v.y *= -1

  -- ball movement
  b.x += b._v.x * 2
  b.y += b._v.y * 1

  -- ball collision detection
  if(collide(p1, b) or
    collide(p2, b)) then
    b._v.x *= -1	
  end
end

function _draw()
  cls()

  print(p1._v.y)

  -- score
  drawscore(p1, 48)
  drawscore(p2, 80)

  -- player 1
  rectfill(p1.x, p1.y, 
  p1.x+pw, p1.y+ph)
  -- player 2
  rectfill(p2.x, p2.y,
  p2.x+pw, p2.y+ph)					
  -- ball
  rectfill(b.x, b.y,
  b.x+bd, b.y+bd)
end
