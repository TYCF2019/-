%1.输入已知数据
clear;
Ax = 0; Ay = 0; Adx = 0; Ady = 0; Addx = 0; Addy = 0;%***A点数据
Bx = 0; Bdx = 0; Bdy = 5; Bddx = 0; Bddy = 0;%***********B点数据
LBC = 90; LBE = 130; LBG = 160; LCG = 70;%***************2杆长度数据
LAC = 100; LAD = 60;%************************************3杆各段长度数据
LDF = 70;%***********************************************4杆长度数据
LFG = 40; LGI = 75;%*************************************5杆长度数据
LEH = 75;%***********************************************6杆长度数据
LHI = 30; LIM = 70; phi = 170;%**************************7杆长度、角度数据
hd = pi/180; du = 180/pi;
phi = phi*hd;
n1 = 0;

%2.调用子函数RRR、RR计算各个杆件和点的位移、速度、加速度
for i = -180:-20
    By = i;
    n1 = n1+1;
    [Cx,Cy,Cdx,Cdy,Cddx,Cddy,theta_AC, theta_BC,omega_AC,omega_BC,alpha_AC,alpha_BC]...
        = RRR(Ax,Ay,Adx,Ady,Addx,Addy,Bx,By,Bdx,Bdy,Bddx,Bddy,LAC,LBC,0);
    [Dx,Dy,Ddx,Ddy,Dddx,Dddy] = RR(Ax,Ay,Adx,Ady,Addx,Addy,theta_AC,omega_AC,alpha_AC,LAD);
    [Ex,Ey,Edx,Edy,Eddx,Eddy] = RR(Bx,By,Bdx,Bdy,Bddx,Bddy,theta_BC,omega_BC,alpha_BC,LBE);
    [Fx,Fy,Fdx,Fdy,Fddx,Fddy] = RR(Dx,Dy,Ddx,Ddy,Dddx,Dddy,theta_BC,omega_BC,alpha_BC,LDF);
    [Gx,Gy,Gdx,Gdy,Gddx,Gddy] = RR(Bx,By,Bdx,Bdy,Bddx,Bddy,theta_BC,omega_BC,alpha_BC,LBG);
    [Ix,Iy,Idx,Idy,Iddx,Iddy] = RR(Gx,Gy,Gdx,Gdy,Gddx,Gddy,theta_AC,omega_AC,alpha_AC,LGI);
    [Hx,Hy,Hdx,Hdy,Hddx,Hddy,theta_EH, theta_IH,omega_EH,omega_IH,alpha_EH,alpha_IH]...
        = RRR(Ex,Ey,Edx,Edy,Eddx,Eddy,Ix,Iy,Idx,Idy,Iddx,Iddy,LEH,LHI,1);
    [Mx,My,Mdx,Mdy,Mddx,Mddy] = RR(Ix,Iy,Idx,Idy,Iddx,Iddy,theta_IH+phi,omega_IH,alpha_IH,LIM);
    XB(n1) = Bx; YB(n1) = By;
    XC(n1) = Cx; YC(n1) = Cy;
    XD(n1) = Dx; YD(n1) = Dy;
    XE(n1) = Ex; YE(n1) = Ey;
    XF(n1) = Fx; YF(n1) = Fy;
    XG(n1) = Gx; YG(n1) = Gy;
    XH(n1) = Hx; YH(n1) = Hy;
    XI(n1) = Ix; YI(n1) = Iy;
    XM(n1) = Mx; YM(n1) = My;
    DXM(n1) = Mdx; DYM(n1) = Mdy;
    DDXM(n1) = Mddx; DDYM(n1) = Mddy;
end

%3.位移、速度、加速度和八连杆机构图形输出
figure(1);
j = -180:-20;
subplot(2,3,1);     %绘x位移线图
plot(j,XM,'c');
title('M点x位移线图');
xlabel('移动副位置 By mm')
ylabel('x位移 mm')
grid on; hold on;

subplot(2,3,2);     %绘y位移线图
plot(j,YM,'m');
title('M点y位移线图');
xlabel('移动副位置 By mm')
ylabel('y位移 mm')
grid on; hold on;

subplot(2,3,3);     %绘x速度线图
plot(j,DXM,'y');
title('M点x速度线图');
xlabel('移动副位置 By mm')
ylabel('x速度 mm/s')
grid on; hold on;

subplot(2,3,4);     %绘y速度线图
plot(j,DYM,'r');
title('M点y速度线图');
xlabel('移动副位置 By mm')
ylabel('y速度 mm')
grid on; hold on;

subplot(2,3,5);     %绘x加速度线图
plot(j,DDXM,'g');
title('M点x加速度线图');
xlabel('移动副位置 By mm')
ylabel('x加速度 mm/s^2')
grid on; hold on;

subplot(2,3,6);     %绘y加速度线图
plot(j,DDYM,'b');
title('M点y加速度线图');
xlabel('移动副位置 By mm')
ylabel('y加速度 mm/s^2')
grid on; hold on;

%4.连杆机构仿真图像输出
figure(2);
m = moviein(20);
k=0;
for n2 = -180:-20
    k = k+1;
    clf;
    x(1) = 0; y(1) = 0;
    x(2) = XB(k);y(2) = YB(k);
    x(3) = XC(k);y(3) = YC(k);
    x(4) = XD(k);y(4) = YD(k);
    x(5) = XE(k);y(5) = YE(k);
    x(6) = XF(k);y(6) = YF(k);
    x(7) = XG(k);y(7) = YG(k);
    x(8) = XH(k);y(8) = YH(k);
    x(9) = XI(k);y(9) = YI(k);
    x(10) = XM(k);y(10) = YM(k);
    plot([x(1),x(2)],[y(1),y(2)]);
    grid on; hold on;
    plot([x(2),x(7)],[y(2),y(7)]);
    grid on; hold on;
    plot([x(1),x(3)],[y(1),y(3)]);
    grid on; hold on;
    plot([x(4),x(6)],[y(4),y(6)]);
    grid on; hold on;
    plot([x(5),x(8)],[y(5),y(8)]);
    grid on; hold on;
    plot([x(6),x(9)],[y(6),y(9)]);
    grid on; hold on;
    plot([x(8),x(9)],[y(8),y(9)]);
    grid on; hold on;
    plot([x(9),x(10)],[y(9),y(10)]);
    grid on; hold on;
    plot(x(1),y(1),'o');
    plot(x(2),y(2),'s');
    plot(x(3),y(3),'o');
    plot(x(4),y(4),'o');
    plot(x(5),y(5),'o');
    plot(x(6),y(6),'o');
    plot(x(7),y(7),'o');
    plot(x(8),y(8),'o');
    plot(x(9),y(9),'o');
    plot(x(10),y(10),'o');
    axis([-20 300 -350 20]);
    m(k) = getframe;
    MakeGif('My.Gif',k);
end
movie(m);

%I点
%     [Px,Py,Pdx,Pdy,Pddx,Pddy] = RR(Hx,Hy,Hdx,Hdy,Hddx,Hddy,theta_BC,omega_BC,alpha_BC,LHI);
%C点
%     [Qx,Qy,Qdx,Qdy,Qddx,Qddy] = RR(Bx,By,Bdx,Bdy,Bddx,Bddy,theta_BC,omega_BC,alpha_BC,LBC);
%     [Nx,Ny,Ndx,Ndy,Nddx,Nddy] = RR(Ax,Ay,Adx,Ady,Addx,Addy,theta_AC,omega_AC,alpha_AC,LAC);

%     Dx = (LAD/LAC)*Cx;      Dy = (LAD/LAC)*Cy;
%     Ddx = (LAD/LAC)*Cdx;    Ddy = (LAD/LAC)*Cdy;
%     Dddx = (LAD/LAC)*Cddx;  Dddy = (LAD/LAC)*Cddy;

%     phi1=theta_BC*du;
%     phi2=theta_DC*du;
%     plot(x,y);
%     grid on; hold on;