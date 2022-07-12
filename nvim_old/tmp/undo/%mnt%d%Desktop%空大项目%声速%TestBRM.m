Vim�UnDo� �&��H��%��PX�㌅�HmGBi��   �   clear;                             b���    _�                     �        ����                                                                                                                                                                                                                                                                                                                                                             b���    �   �               �   �            5��    �                      D                     �    �                      D                     �    �                     D                    �    �                     D                    �    �                     D                    �    �                     D                    �    �                      D                     5�_�                     �        ����                                                                                                                                                                                                                                                                                                                                                  V        b���     �          �      clear;�       �           �                clear;�                clc;�                IC = CreateInputStiffnessMatrix(125, 8, 6.5, 14, 6.5, 14, 3.75, 5.5, 5.5);�                rho = 1500;�                
alpha = 0;�                % 阵元数目�                N = 64;�      	          % 阵元坐标数组�   	   
          Xt = zeros(1, N);�   
             Zt = zeros(1, N);�                % 阵元间隙�                pitch = 0.3175e-3;�                % 工件长宽�                Lx = 20e-3;�                % Lx = 10e-3;�                Lz = 5.92e-3;�                dx = 0.2e-3;�                dz = 0.185e-3;�                % 工件最左侧位置�                StartX = -10e-3;�                % StartX = -5e-3;�                StartZ = Lz;�                % 是否使用楔块�                wedge.used = 0;�                % wedge.used = 1;�                % 楔块声速�                wedge.speed = 2337;�                % 第一晶片高度�                wedgde.z1 = Lz + 20e-3;�                 �                 if wedge.used == 0�       !              wedge.z1 = Lz;�   !   "          end�   "   #           �   #   $          % 面内角定义�   $   %          -% sample.stack = [0, 45, 90, 135] / 180 * pi;�   %   &          $% sample.stack = [0, 90] / 180 * pi;�   &   '          % sample.stack = 90 / 180 * pi;�   '   (          % sample.stack = 0 / 180 * pi;�   (   )          �sample.stack = [45, 90, -45, 0, 45, 90, -45, 0, 45, 90, -45, 0, 45, 90, -45, 0, 0, -45, 90, 45, 0, -45, 90, 45, 0, -45, 90, 45, 0, -45, 90, 45, ] / 180 * pi;�   )   *           �   *   +          % 创建坐标�   +   ,          Nx = floor(Lx / dx) + 1;�   ,   -          Nz = floor(Lz / dz) + 1;�   -   .          X = zeros(1, Nx * Nz);�   .   /          Z = zeros(1, Nx * Nz);�   /   0          Nvect_X = zeros(1, Nx * Nz);�   0   1          Nvect_Z = zeros(1, Nx * Nz);�   1   2          % 创建阵元坐标�   2   3          for i = 1:N�   3   4          %    Xt(i) = -10e-3 + (i - 1) * pitch;�   4   5              Zt(i) = wedge.z1;�   5   6          end�   6   7           �   7   8          % 创建离散点坐标�   8   9          for i = 1:Nx * Nz�   9   :              resX = mod(i, Nx);�   :   ;              Nvect_X(i) = 0;�   ;   <              Nvect_Z(i) = -1;�   <   =           �   =   >              if resX == 0�   >   ?          &        X(i) = StartX + (Nx - 1) * dx;�   ?   @          *        Z(i) = StartZ - (i / Nx - 1) * dz;�   @   A              else�   A   B          (        X(i) = StartX + (resX - 1) * dx;�   B   C          +        Z(i) = StartZ - floor(i / Nx) * dz;�   C   D              end�   D   E           �   E   F          end�   F   G           �   G   H          stp = Nx + 1 - Nx * wedge.used;�   H   I          X = X(stp:end);�   I   J          Z = Z(stp:end);�   J   K           �   K   L          if wedge.used == 0�   L   M              Nz = Nz - 1;�   M   N          end�   N   O           �   O   P          % 画阵元�   P   Q          
figure(1);�   Q   R          )% scatter(Xt, Zt, 20, 'green', 'filled');�   R   S          hold on; axis equal;�   S   T          % 画离散点�   T   U          %% scatter(X, Z, 3, 'blue', 'filled');�   U   V          ?[meshX, meshZ] = meshgrid(StartX:dx:StartX + Lx, StartZ:-dz:0);�   V   W          -% scatter(meshX, meshZ, 3, 'blue', 'filled');�   W   X          [row, ~] = size(meshX);�   X   Y           �   Y   Z          for r = 1:row�   Z   [          =    plot(meshX(r, :), meshZ(r, :), 'blue', 'LineWidth', 0.5);�   [   \          end�   \   ]           �   ]   ^          ?% scatter(X(endpoint - 1), Z(endpoint - 1), 20, 'k', 'filled');�   ^   _          !set(gca, 'XAxisLocation', 'top');�   _   `          1%将x轴方向设置为普通(从左到右递增)�   `   a          set(gca, 'XDir', 'normal');�   a   b          (%将y轴的位置设置在左边(默认)�   b   c          "set(gca, 'YAxisLocation', 'left');�   c   d          % 文件名�   d   e          loader = mod_ascan_loader;�   e   f          5FullMatrix = loader.LoadElemAScan('no_defect.ascan');�   f   g          	T = 1501;�   g   h          time = 1:T;�   h   i          time = time ./ 50e6;�   i   j          depth = time .* 2900 .* 1000;�   j   k           �   k   l          % 第一阵元的状态矩阵�   l   m          kdst = CreateCFPRStateMatrix(Xt(1), Zt(1), X, Z, Nx, Nz, wedge.used, wedge.speed, sample.stack, rho, C, []);�   m   n           �   n   o          for n = 1:N�   o   p              disp([n, N]);�   p   q           �   q   r              if n == 1�   r   s                  dist(:, :, n) = dst;�   s   t              else�   t   u          ~        dist(:, :, n) = CreateCFPRStateMatrix(Xt(n), Zt(n), X, Z, Nx, Nz, wedge.used, wedge.speed, sample.stack, rho, C, dst);�   u   v              end�   v   w           �   w   x          i    [law(:, n), before_point(:, n)] = CreateFocalLowWithWedge(dist(:, :, n), Xt(n), Zt(n), X, Z, Nx, Nz);�   x   y          end�   y   z           �   z   {          Time = zeros(3, N);�   {   |          	c = 2900;�   |   }          $x0 = (Xt(1) + Xt(1)) / 2; z0 = 0e-3;�   }   ~          Aendpoint0 = ceil(((Z(1) - z0) / dz) * Nx + (x0 - X(1)) / dx + 2);�   ~              �      �          for n = 1:N�   �   �          &    x = (Xt(1) + Xt(n)) / 2; z = 0e-3;�   �   �          B    endpoint = ceil(((Z(1) - z) / dz) * Nx + (x - X(1)) / dx + 2);�   �   �          +    pointlayer = ceil((endpoint - 1) / Nx);�   �   �              % 画图显示最短路径�   �   �          /    if n == 16 || n == 32 || n == 48 || n == 64�   �   �           �   �   �                  if n == 16�   �   �                      color = 'r';�   �   �                  elseif n == 32�   �   �                      color = 'g';�   �   �                  elseif n == 48�   �   �                      color = 'm';�   �   �                  else�   �   �                      color = 'k';�   �   �                  end�   �   �           �   �   �          �        h(n) = PictureRaytracePath(before_point(:, 1), Xt(1), Zt(1), X, Z, dx, Nvect_X, Nvect_Z, endpoint, pointlayer, color, 2, 0);�   �   �          �        h(n) = PictureRaytracePath(before_point(:, n), Xt(n), Zt(n), X, Z, dx, Nvect_X, Nvect_Z, endpoint, pointlayer, color, 2, 0);�   �   �              end�   �   �           �   �   �          :    t1_11 = 2 * sqrt((x0 - Xt(1))^2 + (z0 - Zt(1))^2) / c;�   �   �          \    t1_1n = (sqrt((x - Xt(1))^2 + (z - Zt(1))^2) + sqrt((x - Xt(n))^2 + (z - Zt(n))^2)) / c;�   �   �          +    Time(1, n) = (t1_1n - t1_11) / 2 * 1e6;�   �   �           �   �   �          &    t2_11 = 2 * law(endpoint0 + 1, 1);�   �   �          8    t2_1n = law(endpoint + 1, 1) + law(endpoint + 1, n);�   �   �          %    Time(2, n) = (t2_1n - t2_11) / 2;�   �   �           �   �   �          $    d11 = t2_11 * 1e-6 * 2900 * 1e3;�   �   �          $    d1n = t2_1n * 1e-6 * 2900 * 1e3;�   �   �          3    [~, ind] = findpeaks(abs(FullMatrix(:, 1, n)));�   �   �          :    %     [~, ind1] = findpeaks(abs(FullMatrix(:, 1, n)));�   �   �          ;    %     [~, ind2] = findpeaks(-abs(FullMatrix(:, 1, n)));�   �   �          #    %     ind = cat(1, ind1, ind2);�   �   �          *    [~, id1] = min(abs(depth(ind) - d11));�   �   �          *    [~, id2] = min(abs(depth(ind) - d1n));�   �   �          (    t3_11 = depth(ind(id1)) * 1e-3/2900;�   �   �          (    t3_1n = depth(ind(id2)) * 1e-3/2900;�   �   �          ,    Time(3, n) = (t3_1n - t3_11) / 2 .* 1e6;�   �   �          end�   �   �           �   �   �          �legend([h(16), h(32), h(48), h(64)], '第1个阵元发射，第16个阵元接收', '第1个阵元发射，第32个阵元接收', '第1个阵元发射，第48个阵元接收', '第1个阵元发射，第64个阵元接收');�   �   �          figure(2); hold on;�   �   �          ele = 1:64;�   �   �          ?h1 = plot(ele, Time(1, :), 'k', 'LineWidth', 1, 'Marker', 's');�   �   �          -set(h1, 'MarkerFaceColor', get(h1, 'color'));�   �   �          ?h2 = plot(ele, Time(2, :), 'r', 'LineWidth', 1, 'Marker', 'o');�   �   �          -set(h2, 'MarkerFaceColor', get(h2, 'color'));�   �   �          % plot(ele, Time(3, :));�   �   �           p = polyfit(ele, Time(3, :), 3);�   �   �          val = polyval(p, ele);�   �   �          val(1) = 0;�   �   �          !val(2) = (val(1) + val(4)) * 1/3;�   �   �          !val(3) = (val(1) + val(4)) * 2/3;�   �   �          8h3 = plot(ele, val, 'b', 'LineWidth', 1, 'Marker', '^');�   �   �          -set(h3, 'MarkerFaceColor', get(h3, 'color'));�   �   �          ,ylabel("qP传播时间差(t1j-t11)/2 (us)");�   �   �          xlabel("第j个接收阵元");�   �   �          @legend('均质化处理', '声线示踪法', '后壁反射法');�   �   �          (% 为了使用original画图保存数据�   �   �          %ele = ele'; Time = Time'; val = val';�   �   �          &save('BRM.mat', 'ele', 'Time', 'val');5��                                                �            �                       E              �                                                �                                                �                                         J       �                          W                      �                          c                      �                          n                      �                          }                      �                          �                      �    	                      �                      �    
                      �                      �                          �                      �                          �                      �                          �                      �                          �                      �                          �                      �                          	                     �                                               �                          $                     �                          3                     �                          K                     �                          \                     �                          n                     �                          {                     �                          �                     �                          �                     �                          �                     �                          �                     �                          �                     �                          �                     �                                               �                                               �                                                �    !                      )                     �    "                      -                     �    #                      .                     �    $                      @              .       �    %                      n              %       �    &                      �                      �    '                      �                     �    (                      �              �       �    )                      p                     �    *                      q                     �    +                      �                     �    ,                      �                     �    -                      �                     �    .                      �                     �    /                      �                     �    0                      �                     �    1                                           �    2                      /                     �    3                      ;              &       �    4                      a                     �    5                      w                     �    6                      {                     �    7                      |                     �    8                      �                     �    9                      �                     �    :                      �                     �    ;                      �                     �    <                      �                     �    =                      �                     �    >                      �              '       �    ?                                    +       �    @                      J              	       �    A                      S              )       �    B                      |              ,       �    C                      �                     �    D                      �                     �    E                      �                     �    F                      �                     �    G                      �                      �    H                      �                     �    I                      �                     �    J                      �                     �    K                      �                     �    L                      
                     �    M                                           �    N                                           �    O                                            �    P                      ,                     �    Q                      7              *       �    R                      a                     �    S                      v                     �    T                      �              &       �    U                      �              @       �    V                      �              .       �    W                                           �    X                      1                     �    Y                      2                     �    Z                      @              >       �    [                      ~                     �    \                      �                     �    ]                      �              @       �    ^                      �              "       �    _                      �              2       �    `                                           �    a                      3              )       �    b                      \              #       �    c                                           �    d                      �                     �    e                      �              6       �    f                      �              
       �    g                      �                     �    h                      �                     �    i                      	                     �    j                      %	                     �    k                      &	                     �    l                      D	              l       �    m                      �	                     �    n                      �	                     �    o                      �	                     �    p                      �	                     �    q                      �	                     �    r                      �	                     �    s                      �	              	       �    t                      
                     �    u                      �
                     �    v                      �
                     �    w                      �
              j       �    x                      �
                     �    y                      �
                     �    z                      �
                     �    {                                    
       �    |                                    %       �    }                      >              B       �    ~                      �                     �                          �                     �    �                      �              '       �    �                      �              C       �    �                      �              ,       �    �                      #                     �    �                      B              0       �    �                      r                     �    �                      s                     �    �                      �                     �    �                      �                     �    �                      �                     �    �                      �                     �    �                      �                     �    �                      �                     �    �                                           �    �                      %                     �    �                      1                     �    �                      2              �       �    �                      �              �       �    �                      <                     �    �                      D                     �    �                      E              ;       �    �                      �              ]       �    �                      �              ,       �    �                      	                     �    �                      
              '       �    �                      1              9       �    �                      j              &       �    �                      �                     �    �                      �              %       �    �                      �              %       �    �                      �              4       �    �                                    ;       �    �                      J              <       �    �                      �              $       �    �                      �              +       �    �                      �              +       �    �                                     )       �    �                      )              )       �    �                      R              -       �    �                                           �    �                      �                     �    �                      �              �       �    �                      b                     �    �                      v                     �    �                      �              @       �    �                      �              .       �    �                      �              @       �    �                      0              .       �    �                      ^                     �    �                      w              !       �    �                      �                     �    �                      �                     �    �                      �              "       �    �                      �              "       �    �                      �              9       �    �                      8              .       �    �                      f              -       �    �                      �                     �    �                      �              A       �    �                      �              )       �    �                                    &       �    �                      B              '       5��