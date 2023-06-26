function SaveImagesAsPDF(imageCell)
    % Create a new figure
    fig = figure('Visible', 'off');

    % Set the desired paper size for A4
    paperSize = [210*5, 297*5];  % Width and height in millimeters

    % Create a temporary folder to store individual PDF pages
    tempFolder = fullfile(tempdir, 'PDFPages');
    mkdir(tempFolder);

    % Iterate over the images in the cell
    for i = 1:numel(imageCell)
        % Get the current image
        currentImage = imageCell{i};

        % Create a new subplot
        subplot('Position', [0, 0, 1, 1]);

        % Display the current image on the subplot
        imshow(currentImage, 'Border', 'tight', 'InitialMagnification', 'fit');

        % Save the subplot as a PDF page
        pageFilePath = fullfile(tempFolder, sprintf('Page_%02d.pdf', i));
        print(fig, pageFilePath, '-dpdf', '-r300', '-painters');
    end

    % Close the figure
    close(fig);

    % Prompt the user to select the output file path
    [fileName, pathName] = uiputfile('*.pdf', 'Save PDF as');
    if isequal(fileName, 0) || isequal(pathName, 0)
        % User canceled the dialog, return without saving
        return;
    end

    % Get the full paths of the PDF files in the temporary folder
    pdfFiles = dir(fullfile(tempFolder, '*.pdf'));
    pdfPaths = fullfile({pdfFiles.folder}, {pdfFiles.name});

    % Combine all the PDF pages into a single document
    combinedFilePath = fullfile(pathName, fileName);
    append_pdfs(combinedFilePath, pdfPaths{:});
    
    % Remove the temporary folder and files
    rmdir(tempFolder, 's');
end
