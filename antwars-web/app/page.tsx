'use client';

import { useEffect, useRef } from 'react';
import Head from 'next/head';

export default function Home() {
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    // Dynamically load Ruffle
    const script = document.createElement('script');
    script.src = '/ruffle.js';
    script.onload = () => {
      // @ts-ignore
      const ruffle = window.RufflePlayer.newest();
      const player = ruffle.createPlayer();
      if (containerRef.current) {
        containerRef.current.appendChild(player);
        player.load({
          url: "antwars.swf", // Loaded from /public
          backgroundColor: "#000000",
          allowScriptAccess: true,
          logLevel: "warn",
        });
      }
    };
    document.body.appendChild(script);

    return () => {
      document.body.removeChild(script);
    };
  }, []);

  return (
    <div style={{
      display: 'flex',
      justifyContent: 'center',
      alignItems: 'center',
      height: '100vh',
      backgroundColor: '#000'
    }}>
      <div
        ref={containerRef}
        style={{ width: '1365px', height: '768px' }}
      />
    </div>
  );
}
