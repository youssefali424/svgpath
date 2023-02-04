// Copyright (c) 2016, SlickTech. All rights reserved. Use of this source code
// is governed by a MIT license that can be found in the LICENSE file.

import '../lib/src/svgpath.dart';
import '../lib/src/bounding_box.dart';
import 'package:test/test.dart';

void main() {
  test('bounding box', () {
    expect(new SvgPath('M300,200 h-150 a150,150 0 1,0 150,-150 z').boundingBox,
        equals(new BoundingBox(150, 50, 300, 300)));

    expect(
        new SvgPath(
                'M600,350 l 50,-25             a25,25 -30 0,1 50,-25 l 50,-25             a25,50 -30 0,1 50,-25 l 50,-25             a25,75 -30 0,1 50,-25 l 50,-25             a25,100 -30 0,1 50,-25 l 50,-25')
            .boundingBox!
            .round(2),
        equals(new BoundingBox(600, 64.83, 450, 285.17)));

    expect(
        new SvgPath(
                'M0 1665q0 38 29 64 27 27 65 27h627q41 0 72.5 30t31.5 73-31.5 74-72.5 31-73-32q-29-26-65-26-38 0-64 25.5t-26 63.5 26 64q85 85 202 85 118 0 201-83.5t83-201.5-83-202-201-84H94q-38 0-66 27.5T0 1665zm0-321q0 35 29 61 27 27 65 27h1170q118 0 201.5-83.5T1549 1147t-83-200-202-82q-121 0-201 81-25 26-25 65t24.5 63.5 63.5 24.5q38 0 66-25 30-30 72-30t72.5 30 30.5 73-30.5 74-72.5 31H94q-38 0-66 27.5T0 1344zm283-251q0 13 18 13h153q11 0 21-15 36-87 111.5-143.5T757 884l56-8q20 0 20-18l7-55q17-173 146-289t304-116q176 0 305.5 115.5T1743 803l7 62q0 19 19 19h174q144 0 245.5 100.5T2290 1227q0 143-101.5 244.5T1943 1573h-736q-20 0-20 19v146q0 18 20 18h736q143 0 264.5-71t192-193 70.5-265q0-118-45-216 121-159 121-353 0-150-75.5-279T2266 174.5 1987 99q-247 0-412 185-128-65-285-65-225 0-398 139.5T672 715q-136 32-240.5 131T286 1080v4q-3 5-3 9zM1155-83q0 37 29 64l65 69q26 26 65 26 40 0 65.5-24.5T1405-13q0-38-24-64l-70-69q-25-28-63-28t-65.5 27-27.5 64zm568 470q115-109 264-109 155 0 267.5 112T2367 658q0 104-55 195-153-153-369-153h-36q-38-173-184-313zm173-559q0 37 26.5 62.5T1987-84t65-25.5 27-62.5v-218q0-38-27-65t-65-27-64.5 27-26.5 65v218zm592 242q0 39 24 64 27 27 65 27.5t61-27.5l156-153q27-27 27-65 0-37-27-64t-65-27-64 26L2512 8q-24 25-24 62zm82 1262q0 37 27 64l68 69q32 26 66 26 31 0 63-26 27-27 27-64 0-35-27-65l-68-69q-26-26-62-26-40 0-67 26.5t-27 64.5zm161-674q0 38 27 63 24 28 61 28h216q38 0 65-27t27-64-27.5-64.5T3035 566h-216q-38 0-63 27t-25 65z')
            .boundingBox,
        equals(new BoundingBox(0, -482, 3127, 2626)));

    expect(
        new SvgPath(
            'M0 753q0-150 96.5-267T343 334q36-178 181.5-293.5T857-75q180 0 320.5 110.5T1361 324h30q121 0 226 52t167.5 142.5T1847 715q0 180-138 305 0 56-34.5 128.5T1582 1280t-117 72q-20 99-92 167t-174 91q48 48 48 113 0 79-56 134.5t-135 55.5q-78 0-134-55.5T866 1723q0-9 4.5-28t4.5-29h-9q-94 0-161-67.5T638 1437q0-37 39-113-78-41-125-134H419q-175-15-297-138.5T0 753z')
            .boundingBox,
        equals(new BoundingBox(0, -75, 1847, 1988)));

    expect(
        new SvgPath(
            'M0 1226q0 178 106 318t273 187l-68 179q-8 23 15 23h226l-111 447h30l423-600q6-7 1.5-15t-15.5-8H648l264-492q11-23-15-23H583q-14 0-24 15l-114 306q-114-28-188.5-122T182 1226q0-133 89.5-230.5T495 882l57-4q19 0 19-19l8-57q11-113 74-206.5T815.5 449t214.5-53q173 0 303 117t148 289l8 60q0 20 18 20h173q142 0 245.5 102t103.5 242q0 138-96 239.5T1701 1574q-21 0-21 19v143q0 18 21 18 139-4 256-76.5t184-192.5 67-259q0-117-45-214 125-148 125-353 0-113-44.5-216T2124 265t-178-119.5-216-44.5q-247 0-412 185-129-69-288-69-225 0-400 139.5T406 714q-176 41-291 184.5T0 1226zm846 1054q0 26 15.5 49t48.5 33q3 0 8.5 1t10 1.5 8.5.5q67 0 85-64l259-948q10-37-7-68.5t-52-42.5q-37-11-69.5 6.5T1110 1302l-261 949q-3 27-3 29zm442-324q0 64 66 85 27 3 28 3 18 0 37-8 32-14 45-59l175-624q10-37-8-68.5t-54-42.5q-37-11-69 6.5t-42 53.5l-173 628q-5 23-5 26zm178-1568q108-102 264-102 155 0 265 109t110 264q0 101-54 197-154-154-371-154h-34q-45-183-180-314z')
            .boundingBox,
        equals(new BoundingBox(0, 101, 2288, 2279)));
  });
}
