function [L,a,b]=RGBtoLAB(R,G,B)

var_R = double(R)./255;
var_G = double(G)./255;
var_B = double(B)./255;

for ii = 1:length(var_R(:,1))
    for jj = 1:length(var_R(1,:))
        if (var_R(ii,jj)>0.04045)
            var_R(ii,jj) = ((var_R(ii,jj)+0.055)/1.055)^2.4;
        else
            var_R(ii,jj) = var_R(ii,jj)/12.92;
        end
        
        if (var_G(ii,jj)>0.04045)
            var_G(ii,jj) = ((var_G(ii,jj)+0.055)/1.055)^2.4;
        else
            var_G(ii,jj) = var_G(ii,jj)/12.92;
        end
        
        if (var_B(ii,jj)>0.04045)
            var_B(ii,jj) = ((var_B(ii,jj)+0.055)/1.055)^2.4;
        else
            var_B(ii,jj) = var_B(ii,jj)/12.92;
        end
    end
end

var_R = var_R.*100;
var_G = var_G.*100;
var_B = var_B.*100;

%Observer. = 2°, Illuminant = D65
x = var_R.*0.4124+var_G.*0.3576+var_B.*0.1805;
y = var_R.*0.2126+var_G.*0.7152+var_B.*0.0722;
z = var_R.*0.0193+var_G.*0.1192+var_B.*0.9505;

%Observer. = 2°, Illuminant = D65
ref_X =  95.047;
ref_Y = 100.000;
ref_Z = 108.883;

var_X = x./ref_X;
var_Y = y./ref_Y;
var_Z = z./ref_Z;

% vizedeki hata buradan kaynaklıymış döngü ile kontrol edildi
% hızlandırılmak için matris kontrolü konulmalı
for ii = 1:length(var_X(:,1))
    for jj = 1:length(var_X(1,:))
        if (var_X(ii,jj)>0.008856)
            var_X(ii,jj) = var_X(ii,jj)^(1/3);
        else
            var_X(ii,jj) = (7.787*var_X(ii,jj))+(16/116);
        end
        
        if (var_Y(ii,jj)>0.008856)
            var_Y(ii,jj) = var_Y(ii,jj)^(1/3);
        else
            var_Y(ii,jj) = (7.787*var_Y(ii,jj))+(16/116);
        end
        
        if (var_Z(ii,jj)>0.008856)
            var_Z(ii,jj) = var_Z(ii,jj)^(1/3);
        else
            var_Z(ii,jj) = (7.787*var_Z(ii,jj))+(16/116);
        end
    end
end

L = (116*var_Y)-16;
a = 500*(var_X-var_Y);
b = 200*(var_Y-var_Z);

end