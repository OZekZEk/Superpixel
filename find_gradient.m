function gradient_pixels = find_gradient(image)

width = length(image(1,:,1));
height = length(image(:,1,1));

gradient_pixels = ones(height,width)*255;

for ii = 2:width-1
    for jj = 2:height-1

        g_x = (image(jj+1,ii,1)-image(jj-1,ii,1))^2+(image(jj+1,ii,2)-image(jj-1,ii,3))^2+(image(jj+1,ii,3)-image(jj-1,ii,3))^2;
        g_y = (image(jj,ii+1,1)-image(jj,ii-1,1))^2+(image(jj,ii+1,2)-image(jj,ii-1,3))^2+(image(jj,ii+1,3)-image(jj,ii-1,3))^2;

        gradient_pixels(jj,ii) = sqrt(double(g_x))+sqrt(double(g_y));


    end
end

end