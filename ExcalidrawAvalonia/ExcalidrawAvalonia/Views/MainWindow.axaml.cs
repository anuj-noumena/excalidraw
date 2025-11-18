using Avalonia.Controls;
using Avalonia.Interactivity;
using ExcalidrawAvalonia.ViewModels;

namespace ExcalidrawAvalonia.Views;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
    }

    private void OnExit(object? sender, RoutedEventArgs e)
    {
        Close();
    }

    private void OnAbout(object? sender, RoutedEventArgs e)
    {
        // TODO: Show about dialog
        var dialog = new Window
        {
            Title = "About Excalidraw Avalonia",
            Width = 400,
            Height = 300,
            Content = new StackPanel
            {
                Margin = new Avalonia.Thickness(20),
                Spacing = 10,
                Children =
                {
                    new TextBlock { Text = "Excalidraw Avalonia", FontSize = 24, FontWeight = Avalonia.Media.FontWeight.Bold },
                    new TextBlock { Text = "Version 1.0.0" },
                    new TextBlock { Text = "A comprehensive port of Excalidraw to Avalonia UI", TextWrapping = Avalonia.Media.TextWrapping.Wrap },
                    new TextBlock { Text = "\nFeatures:", FontWeight = Avalonia.Media.FontWeight.Bold },
                    new TextBlock { Text = "• Hand-drawn aesthetic with Skia rendering" },
                    new TextBlock { Text = "• Multiple drawing tools" },
                    new TextBlock { Text = "• Export to PNG, SVG, JSON" },
                    new TextBlock { Text = "• Undo/Redo support" },
                    new TextBlock { Text = "\nBased on Excalidraw (excalidraw.com)", TextWrapping = Avalonia.Media.TextWrapping.Wrap }
                }
            }
        };
        dialog.ShowDialog(this);
    }
}
