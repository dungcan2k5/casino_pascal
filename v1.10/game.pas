uses crt;
var key_inp, a,  path  : string;
    end_menu,  path_folder : text;
    num_player : integer;
    game_mode, ket_qua, nguoi_choi, du_doan : text;
    

procedure draw_logo(time_delay : integer);  {Vẽ Logo Game, time_delay là thời gian nghỉ giữa các dòng}
    var logo : text; 
        a: string;

    begin
        assign(logo, path + '\logo.txt'); reset(logo);

        while not eof(logo) do
            begin
                readln(logo,a);
                textcolor(2);
                writeln(a);
                delay(time_delay);
            end;
        close(logo);
    end;

procedure draw_menu;    {Vẽ Menu Game}
    var menu : text; 
        a: string;

    begin
        assign(menu, path + '\menu.txt'); reset(menu);

        while not eof(menu) do
            begin
                readln(menu,a);
                textcolor(15);
                writeln(a);
                delay(50);
            end;
        close(menu);
    end;

procedure loading(x,y: integer);    {Loading Animation. X,Y là toạ độ vị trí xuất hiện}
    var i : integer;

    begin
        textcolor(15);
        for i := 1 to 4 do
            begin
                gotoXY(x, y);
                write('               |');delay(60);
                gotoXY(x, y);
                write('               /');delay(60);
                gotoXY(x, y);
                write('               -');delay(60);
                gotoXY(x, y);
                write('               \');delay(60);
                gotoXY(x, y);
                write('               |');delay(60);
                gotoXY(x, y);
                write('               /');delay(60);
                gotoXY(x, y);
                write('               -');delay(60);
                gotoXY(x, y);
                write('               \');delay(60);
                gotoXY(x, y);
            end;
    end;

procedure player_config;    {Nhập dữ liệu đầu vào}
    var i, y, du_doan_so : integer;
        name_player: array [1..100] of string;
        player_predicted : array [1..100] of string;

    begin
        assign(du_doan,  path + '\du_doan.txt'); rewrite(du_doan);
        assign(nguoi_choi,  path + '\nguoi_choi.txt'); rewrite(nguoi_choi);

        {Nhập số lượng người chơi}
        textcolor(15);    
        write('Nhap so luong nguoi choi: ');readln(num_player);

        {Kiểm tra số lượng người chơi}
        while (num_player > 100) or (num_player <= 0) do
            begin
                y := whereY;
                gotoXY(1, y - 1);
                clreol;
                writeln('Gia tri vua nhap khong thoa man, vui long nhap lai!');
                write('Nhap so luong nguoi choi: ');readln(num_player);
            end;
        writeln(nguoi_choi, num_player);

        {Xoá màn hình nhập số lượng người chơi}
        while whereY > 12 do
            begin
                gotoXY(1,y); clreol;
                y := y - 1;
            end;

        {Nhập tên người chơi}
        for i := 1 to num_player do
            begin
                write('Nhap ten nguoi choi thu ', i, ': ');
                readln(name_player[i]);
                writeln(nguoi_choi, name_player[i]);
            end;
        close(nguoi_choi);

        {Xoá màn hình nhập tên người chơi}
        y := whereY;
        while whereY > 12 do
            begin
                gotoXY(1,y); clreol;
                y := y - 1;
            end;

        {Nhập dự đoán}
        textcolor(15);
        for i := 1 to num_player do
            begin
                write('Nhap du doan cua ', name_player[i],': '); 
                readln(player_predicted[i]);
                val(player_predicted[i], du_doan_so);
                while (du_doan_so > 100) or (du_doan_so < 0) do
                    begin
                        y := whereY;
                        gotoXY(1, y);
                        clreol;
                        writeln('Gia tri vua nhap khong thoa man, vui long nhap lai!');
                        write('Nhap du doan cua ', name_player[i],': ');
                        readln(player_predicted[i]);
                        val(player_predicted[i], du_doan_so);
                    end;
                writeln(du_doan, player_predicted[i]);
            end;  
        close(du_doan);        
    
    end;

procedure game_logic;    {Xử lý, đưa ra kết quả}                    
    var result  : string;
        i, count : integer;
        ds_nguoi_choi : array[1..100] of string;
        ds_du_doan : array[1..100] of string; 

    begin
        assign(ket_qua,  path + '\ket_qua.txt'); reset(ket_qua);
        assign(du_doan,  path + '\du_doan.txt'); reset(du_doan);
        assign(nguoi_choi,  path + '\nguoi_choi.txt'); reset(nguoi_choi);            

        writeln;
        readln(ket_qua, result);    {Kết quả}
        readln(nguoi_choi, num_player);    {Số người chơi}

        {Đọc danh sách người chơi}
        i := 1;
        while not eof(nguoi_choi) do
            begin
                readln(nguoi_choi, ds_nguoi_choi[i]);
                i := i + 1;
            end;

        {Đọc danh sách kết quả dự đoán}
        i := 1;
        while not eof(du_doan) do
            begin
                readln(du_doan, ds_du_doan[i]);
                ds_du_doan[i] := upcase(ds_du_doan[i]); 
                i := i + 1;           
            end;

        delay(1000);

        {Xử lý kết quả}
        count := 0;    {Số người đoán trúng}
        for i := 1 to num_player do
            if ds_du_doan[i] = result then
                begin
                    writeln;
                    writeln('CHUC MUNG ', ds_nguoi_choi[i], ' DA DOAN DUNG!');
                    count := count + 1;        
                end;

        if count = 0 then 
            writeln('Tiec qua! Khong ai doan trung ca. Chuc cac ban may man lan sau!!');
        
        delay(2000);

        close(du_doan); close(nguoi_choi); close(ket_qua);    
    end;

procedure game;    {Random kết quả}
    var i, out : integer;
        mode : integer;
        
    begin
        {Đọc dữ liệu cần thiết}
        assign(ket_qua, path + '\ket_qua.txt'); rewrite(ket_qua);
        assign(game_mode,  path + '\game_mode.txt'); reset(game_mode);

        clrscr; randomize;
        draw_logo(0);
        read(game_mode, mode);
        close(game_mode);
        writeln;
        textcolor(15);

        {Quay số}
        write('Ket qua: ');
        textcolor(12);
        for i := 1 to 100 do 
            begin
                gotoXY(10,whereY);
                out := random(100);
                write(out);
                delay(50);
            end;

        delay(1000);

        {Đưa ra kết quả, ghi kết quả ra file}
        if mode = 1 then
            if out mod 2 = 0 then
                begin
                    write(ket_qua, 'CHAN');
                    write('    -    CHAN');
                end
            else
                begin
                    write(ket_qua, 'LE');
                    write('    -    LE');
                end;

        if mode = 3 then
            if out < 50 then
                begin
                    write(ket_qua, 'TAI');
                    write('    -    TAI');
                end
            else
                begin
                    write(ket_qua, 'XIU');
                    write('    -    XIU');
                end;

        if mode = 2 then
            write(ket_qua, out);
             
        close(ket_qua);
        game_logic; 
    end;

procedure game_process;   {Tiến trình} 
    var key_inp : string;

    begin
        assign(game_mode,  path + '\game_mode.txt'); reset(game_mode);

        clrscr;
        draw_logo(0);
        read(game_mode, key_inp);
        close(game_mode);
        textcolor(15);

        {Hiển thị chế độ chơi ra màn hình}
        if key_inp = '1' then
            begin
                writeln('           -------CHAN LE-------');
                writeln;
            end
        else
            if key_inp = '2' then
                begin
                    writeln('           -------CHON SO-------');
                    writeln;
                end
            else
                if key_inp = '3' then
                    begin
                        writeln('           -------TAI XIU-------');
                        writeln;
                    end
                else
                    if key_inp = '4' then
                        exit; 

        player_config;
        game;
    end;



begin
    assign(path_folder, 'path.txt'); reset( path_folder);
    readln(path_folder,  path); close(path_folder);
    assign(game_mode, path + '\game_mode.txt'); rewrite(game_mode);

    clrscr;
    draw_logo(100); delay(100);
    loading(16,10);
    draw_menu;

    {Lựa chọn chế độ chơi}
    key_inp := readkey;
    write(game_mode, key_inp);
    close(game_mode);
    if key_inp = '4' then
        begin
            writeln('Xin chao! Hen gap lai!');
            delay(500); 
            exit;
        end;
    game_process;

    {Lựa chọn chế độ chơi sau lần chơi đầu tiên}
    repeat
        begin
            assign(end_menu, path + '\end_menu.txt'); reset(end_menu);

            while not eof(end_menu) do
                begin
                    readln(end_menu,a);
                    textcolor(15);
                    writeln(a);
                    delay(50);
                end;
            close(end_menu);            

            key_inp := readkey;

            if key_inp = '1' then                
                game_process;

            if key_inp = '2' then
                begin
                    assign(game_mode,  path + '\game_mode.txt'); rewrite(game_mode);
                    clrscr;
                    draw_logo(0);
                    draw_menu;
                    writeln(game_mode, readkey);
                    close(game_mode);
                    game_process;
                end;

            if key_inp = '3' then
                begin
                    writeln('Xin chao! Hen gap lai!');
                    delay(500); 
                    exit;
                end;
        end;
    until(False);      
end.