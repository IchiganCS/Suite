using Avalonia.Controls;
using Avalonia.Headless.XUnit;
using Avalonia.VisualTree;
using Suite.App.ViewModels;
using Suite.App.Views;

namespace Suite.App.Tests;

public class MainWindowTests
{
    [AvaloniaFact]
    public void MainWindow_shows_Inbox_in_textbox()
    {
        var window = new MainWindow { DataContext = new MainViewModel() };
        window.Show();

        var textBox = window.GetVisualDescendants().OfType<TextBox>().Single();

        Assert.Equal("Inbox", textBox.Text);
    }
}