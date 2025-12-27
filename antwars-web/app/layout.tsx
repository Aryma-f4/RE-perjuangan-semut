import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Ant Wars Remake",
  description: "Web Client for Ant Wars",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body style={{ margin: 0 }}>{children}</body>
    </html>
  );
}
