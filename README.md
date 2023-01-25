# Projekt Autonomiczne Roboty Latające
## Dane autora
Autor: Jakub Szczygieł

Numer indeksu: 136631

## Temat projektu
Komunikacja i sterowanie dronem za pośrednictwem MATLABa

## Opis projeku
Zakres podstawowy
- Implementacja modułu dla środowiska MATLAB pozwalającego na komunikację z dronem za pośrednictwem ekosystemu ROS i biblioteki bebop_autonomy.
- Odczyt kompletu danych z sensoryki pokładowej, pobieranie danych z kamery pokładowej w czasie rzeczywistym, odczyt stanu z wewnętrznej maszyny stanu.
- Wydawanie komend z poziomu modułu.

Projekt polegał na stworzeniu systemu do sterowania dronem Bebop2 z aplikacji w Matlabie, która komunikuje się z węzłem bebop_autonomy poprzez system ROS.

## Funkcjonalność zrealizowana
- Interfejs graficzny w aplikacji w Matlabie

![](/Obrazy/GUI.png)

- Łączenie Matlaba z ROSem poprzez adres IP i numer portu mastera
- Wysyłanie poleceń startu, lądowania i przejścia do trybu awaryjnego do drona
- Subskrybcja danych z odometrii i pozycji drona (za pomocą g2rr) w czasie rzeczywistym
- Subskrybcja wybranych elementów ze stanu drona
- Publikowanie zadanych prędkości do drona
- Sterowanie pozycyjne z wykorzystaniem sterownika PID
- Możliwość modyfikacji wartości parametrów sterownika PID w interfejsie graficznym
- Wczytywanie listy sterowań z Matlaba (zarówno prędkości jak i pozycji)
- Zapisywanie trajektorii drona do Matlaba
- Wizualizacja trajektorii drona w Matlabie

![](/Obrazy/Projekt.png)

## Funkcjonalność niezrealizowana
- Uruchomienie systemu w Dockerze
- Sczytywanie obrazu z kamery drona
- Sterowanie rzeczywistym dronem

## Użyte biblioteki
- bebop_autonomy 0.7.0
  - bebop_driver 0.7.1
  - bebop_tools 0.7.0
  - bebop_msgs 0.7.0
  - bebop_description 0.7.0
- parrot-sphinx 1.8
- gazebo to ros repeater
- protobuf 3.19.6
- pyyaml 6.0
- rospkg 1.4.0
- pyparsing 2.4.7
- setuptools 50.3.2

## Procedura uruchomienia
### Przygotowanie środowiska
Aby uruchomić system należy dokonać kilka modyfikacji w użytych bibliotekach:
1. przenieść plik z firmwarem `Pliki/ardrone3-milos_pc.ext2.zip` do folderu `~/Documents`
2. zmodyfikować plik `/opt/parrot-sphinx/usr/share/sphinx/drones/bebop2.drone` aby używał nowego firmware'u (Gotowy plik w folderze Pliki)
3. zmodyfikować plik `~/bebop_ws/src/bebop_driver` aby dron publikował informacje o stanie (Gotowy plik w folderze Pliki)
4. przenieść folder `Pliki/bebop_scripts` do `~/Documents`

### Uruchomienie systemu
1. na maszynie z dronem ustawić zmienne `ROS_IP` i `ROS_MASTER_URI` używając adresu IP po którym ma się ona łączyć z Matlabem.
Przykładowo:
```
export ROS_IP=192.168.0.55
export ROS_MASTER_URI=http://192.168.0.55:11311
```
2. uruchomić symulację drona w Gazebo
```
sphinx /opt/parrot-sphinx/usr/share/sphinx/drones/bebop2.drone::with_front_cam=false
```
3. odczekać aż symulacja się rozpocznie i uruchomić węzeł bebop_autonomy
```
roslaunch bebop_driver bebop_node.launch
```
4. uruchomić węzeł g2rr
```
rosrun g2rr g2r_republisher_node.pyc bebop2
```
5. powyższe czynności można wykonać za pomocą skryptu `Pliki/run_bebop`
6. otworzyć i uruchomić plik `Matlab/GUI.mlapp` w Matlab App Designer
7. wpisać adres IP oraz numer portu (domyślnie 11311) ROS mastera i kliknąć połącz

W tym momencie można sterować dronem za pomocą funkcjonalności dostępnych w aplikacji.
