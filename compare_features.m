function errors = compare_features(og_features, og_labels, labels, feature)
nspeakers = numel(labels);
for sid = 1:nspeakers
    sp_features = og_features(:, og_labels == labels(sid));
    npages = size(sp_features, 2);
    errors(sid) = sum( ...
        (sp_features - repmat(feature, [1 npages])).^2 ...
    , 'all');
end

errors = sqrt(errors);