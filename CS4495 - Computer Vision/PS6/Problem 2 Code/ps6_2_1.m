video = read(VideoReader('pres_debate.avi'));
[sr, sc, sb, sf] = size(video);
num_particles = 200;
sigma_MSE = 2;
sigma_Gauss = 10;
expoDenom = 2 * sigma_MSE ^ 2;
start = [534, 385, 91, 107];
alpha = 0.05;
firstFrame = rgb2gray(video(:, :, :, 1));
template = firstFrame(start(2) : start(2) + start(4) + 1, start(1) : start(1) + start(3) + 1);
[m, n] = size(template);
wm = round((m - 1)/ 2);
wn = round((n - 1)/ 2);
x = cell(sf + 1, 1);
w = cell(sf + 1, 1);
figure, imshow(template);
start_center = [start(2) + wm, start(1) + wn];
winStart = 160;
%figure, imshow(firstFrame)
%rectangle('Position', start,'EdgeColor', 'red');
%hold on
%plot(x_1(:, 2), x_1(:, 1),'*', 'Color', 'green');
x{1, 1} = [randsample(start_center(1) - winStart : start_center(1) + winStart , num_particles, true) ; ...
           randsample(start_center(2) - winStart : start_center(2) + winStart , num_particles, true)]';
w{1, 1} = (1 / num_particles) * ones(num_particles, 1);
visualizeVideo = zeros(sr, sc, sf);
visualizeTemplate = zeros(m, n, sf);
if 1
    for frame = 1 : sf
        nextFrame = rgb2gray(video(:, :, :, frame));
        visualizeVideo(:, :, frame) = im2double(nextFrame);

        %do one pass of the filter
        w_sum = 0;

        x_old = x{frame, 1};
        x_new = 0 * x_old;

        w_old = w{frame, 1};
        w_new = 0 * w_old;

        paddedFrame = padarray(nextFrame, [m, n], 'both', 'symmetric');
        for i = 1 : num_particles
            x_sample = x_old(randsample(1 : num_particles, 1, true, w_old), :);
            x_new(i, :) = [round(x_sample(1) + normrnd(0, sigma_Gauss)), round(x_sample(2) + normrnd(0, sigma_Gauss))];
            x_new(x_new <= 0) = 1;
            if x_new(i, 1) > sr
                x_new(i, 1) = sr;
            end
            if x_new(i, 2) > sc
                x_new(i, 2) = sc;
            end
            visualizeVideo(x_new(i, 1), x_new(i, 2), frame) = 255;
            %Calculate MSE
            up = x_new(i, 1) + m;
            vp = x_new(i, 2) + n;
            image_patch = paddedFrame(up - wm : up + wm, vp - wn : vp + wn);
            particleMSE = 1 / (m * n) * sumsqr(template - image_patch);

            w_new(i) = exp(-(particleMSE / expoDenom));
            w_sum = w_sum + w_new(i);
        end

        w_new = w_new ./ w_sum;

        visualizeTemplate(:, :, frame) = im2double(template);

        %find the best sample
        best = x_new(w_new == max(w_new),:);
        template = alpha .* nextFrame(best(1) - wm : best(1) + wm, best(2) - wn : best(2) + wn) + (1 - alpha) .* template;

        x{frame + 1, 1} = x_new;
        w{frame + 1, 1} = w_new;
        frame
    end
    implay(visualizeVideo, 60)
    implay(visualizeTemplate, 60);
    desiredFrames = [15 50 140];
    for i = 1 : length(desiredFrames)
        figure, imshow(video(:, :, :, desiredFrames(i)));
        hold on
        x_frame = x{desiredFrames(i), 1};
        w_frame = w{desiredFrames(i), 1};
        est = zeros(2, 1);
        dist = 0;
        for j = 1 : num_particles
            est(1) = est(1) +  w_frame(j) * x_frame(j, 1);
            est(2) = est(2) +  w_frame(j) * x_frame(j, 2);
        end
        for j = 1 : num_particles
            vectDist = sqrt((est(1) - x_frame(j, 1))^2 + (est(2) - x_frame(j, 2))^2);
            dist = dist + w_frame(j) * vectDist;
        end
        rect = [est(2) - wm, est(1) - wn, n, m];
        viscircles(round([est(2), est(1)]), round(dist));
        rectangle('Position', round(rect), 'EdgeColor', 'white');
        plot(x_frame(:, 2), x_frame(:, 1),'*', 'Color', 'green');
    end
    S = {x, w};
end