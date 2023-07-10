generateSuperpixels kodunu açın ve direk run edin.

res1.jpg resmi halihazırda çalışıyor olacaktır. Farklı bir resim ile denemek isterseniz kodun çalıştığı klasöre resmi ekleyin ve imread satırında resmin adını ve uzantısını yazınız. (Ör: yeni resmin adı araba.png olsun. image = imread("araba.png");)

d(x,y) ağırlığını arttırmak için m değeri arttırılmalıdır veya süper piksel sayısı arttırılmalıdır.

Kod MATLAB eşdeğeri gibi hızlı çalışmamaktadır. İşlem uzun sürebilir. Özellikle enforce connectivity yapılan yerdeki işlem çok uzun sürmektedir. Lütfen sabırlı olunuz veya daha küçük bir resimde daha az süper piksel ile deneyiniz.

Sorular için iletişim: ozmanzekiyilmaz70@gmail.com 



