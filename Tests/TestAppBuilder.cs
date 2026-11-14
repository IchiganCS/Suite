using Avalonia;
using Avalonia.Headless;
using Suite.App.Tests;

[assembly: AvaloniaTestApplication(typeof(TestAppBuilder))]

namespace Suite.App.Tests;

public class TestAppBuilder
{
    public static AppBuilder BuildAvaloniaApp() => AppBuilder.Configure<App>()
        .UseHeadless(new AvaloniaHeadlessPlatformOptions());
}
